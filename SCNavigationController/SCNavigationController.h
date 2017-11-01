//
//  SCNavigationController.h
//  SCNavigationController
//
//  Created by Stefan Ceriu on 09/11/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

/** Sides on which view controllers may be stacked */
typedef enum {
	SCNavigationControllerPositionTop,
	SCNavigationControllerPositionLeft,
	SCNavigationControllerPositionBottom,
	SCNavigationControllerPositionRight
} SCNavigationControllerPosition;

/**
 * Opration types possible on the navigation controller
 */
typedef NS_OPTIONS(NSInteger, SCNavigationControllerOperation) {
	SCNavigationControllerOperationNone = 0,
	SCNavigationControllerOperationPush = 1 << 0,
	SCNavigationControllerOperationPop = 1 << 1,
};

@protocol SCNavigationControllerDelegate;
@protocol SCEasingFunctionProtocol;
@protocol SCStackLayouterProtocol;

@interface SCNavigationController : UIViewController

#pragma mark - Properties

/** The navigation controller's root view controller. */
@property (nonatomic, strong, readonly) UIViewController *rootViewController;


/** The position at which pushed view controllers are stacked
 * Should only be changed when there are no view controllers
 * pushed on the stack.
 *
 * Default value is set to SCNavigationPositionRight
 */
@property (nonatomic, assign) SCNavigationControllerPosition position;


/** The navigation controller's delegate */
@property (nonatomic, weak) IBOutlet id<SCNavigationControllerDelegate> delegate;


/** The layouter used to layout the view controllers on the stack
 *
 * Default value is set to SCParallaxStackLayouter
 */
@property (nonatomic, strong) id<SCStackLayouterProtocol> layouter;


/** Timing function used in push/pop/navigate operations
 *
 * Default value is set to SCEasingFunctionTypeSineEaseInOut
 */
@property (nonatomic, strong) id<SCEasingFunctionProtocol> easingFunction;


/** Animation duration for push/pop/navigate operations
 *
 * Default value is set to 0.25f
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 * The gesture recognizer involved in navigating the stack
 * Disabled when only the root view controller is present on the stack
 */
@property (nonatomic, readonly) UIGestureRecognizer *interactiveGestureRecognizer;

/**
 * Navigation types allowed through the interactiveGestureRecognizer
 * Defaults to SCNavigationControllerOperation Pop & Push
 */
@property (nonatomic, assign) SCNavigationControllerOperation allowedInteractiveGestureOperations;

/**
 * The width of the area on each side of the navigation controller
 * the interactive gesture can be triggered in
 * Defaults to 30 points
 */
@property (nonatomic, assign) CGFloat interactiveGestureTriggerAreaWidth;

#pragma mark - Methods

/** Creates and returns a new SCNavigationController
 *
 * @param rootViewController The root view controller
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;


/** Pushes a new view controller on the stack
 *
 * @param viewController The view controller to be pushed
 * @param animated Controls whether the pop will be animated
 * @param completion Completion block called when the pop is done
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(void(^)(void))completion;


/** Pops the last view controller from the stack
 *
 * @param animated Controls whether the pop will be animated
 * @param completion Completion block called when the pop is done
 */
- (void)popViewControllerAnimated:(BOOL)animated
                       completion:(void(^)(void))completion;


/** Pops all the view controllers up to and not including 
 * the given one
 *
 * @param viewController The view controller to pop to
 * @param animated Controls whether the pop will be animated
 * @param completion Completion block called when the pop is done
 */
- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                 completion:(void(^)(void))completion;


/** Pops all the view controllers
 *
 * During the animation the layouters will be called and effects will be used
 *
 * @param animated Controls whether the pop will be animated
 * @param completion Completion block called when the pop is done
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated
                             completion:(void(^)(void))completion;


/**
 * @return An NSArray of view controllers that the navigation controller holds
 */
- (NSArray *)viewControllers;


/**
 * @return An NSArray of view controllers that are currently visible. Includes
 * root view controller.
 */
- (NSArray *)visibleViewControllers;

/**
 * @return Float value representing the visible percentage
 * @param viewController The view controller for which to fetch the
 * visible percentage
 *
 * A view controller is visible when any part of it is visible (within the
 * navigation controller's scrollView bounds and not covered by any other view)
 *
 * Ranges from 0.0f to 1.0f
 */
- (CGFloat)visiblePercentageForViewController:(UIViewController *)viewController;

@end

#pragma mark - Delegate

@protocol SCNavigationControllerDelegate <NSObject>

@optional

/** Delegate method that the navigation controller calls when a view controller 
 * becomes visible
 *
 * @param navigationController The calling navigationController
 * @param viewController The view controller that became visible
 */
- (void)navigationController:(SCNavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController;


/** Delegate method that the navigation controller calls when a view controller
 * is hidden
 *
 * @param navigationController The calling navigationController
 * @param viewController The view controller that became visible
 */
- (void)navigationController:(SCNavigationController *)navigationController
       didHideViewController:(UIViewController *)viewController;


/** Delegate method that the navigation controller calls when its scrollView scrolls
 * @param navigationController The calling navigationController
 * @param offset The scrollView's current offset
 *
 */
- (void)navigationController:(SCNavigationController *)navigationController
		didNavigateToOffset:(CGPoint)offset;

@end
