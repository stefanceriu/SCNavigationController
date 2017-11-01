//
//  SCNavigationController.m
//  SCNavigationController
//
//  Created by Stefan Ceriu on 09/11/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCNavigationController.h"

#import "SCStackViewController.h"
#import "SCScrollView.h"

#import "SCParallaxStackLayouter.h"

#import "SCEasingFunction.h"

static const CGFloat kDefaultInteractiveGestureAreaWidth = 30.0f;


@interface SCStackViewController (SCNavigationController)

@property (nonatomic, strong) SCScrollView *scrollView;

@end


@interface SCNavigationController () <SCStackViewControllerDelegate>

@property (nonatomic, strong) SCStackViewController *stackViewController;

@property (nonatomic, weak) UIViewController *lastVisibleViewControllerBeforeRotation;

@end


@implementation SCNavigationController
@dynamic rootViewController;
@dynamic easingFunction;
@dynamic animationDuration;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if(self = [super init]) {
        
        self.position = SCNavigationControllerPositionRight;
		self.allowedInteractiveGestureOperations = SCNavigationControllerOperationPop | SCNavigationControllerOperationPush;
		
        self.stackViewController = [[SCStackViewController alloc] initWithRootViewController:rootViewController];
        [self.stackViewController setDelegate:self];
		[self.stackViewController setShouldBlockInteractionWhileAnimating:YES];
        
        SCStackLayouter *stackLayouter = [[SCParallaxStackLayouter alloc] init];
        [self.stackViewController registerLayouter:stackLayouter forPosition:(SCStackViewControllerPosition)self.position animated:NO];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

	[self setInteractiveGestureTriggerAreaWidth:kDefaultInteractiveGestureAreaWidth];
	
    [self addChildViewController:self.stackViewController];
    [self.view addSubview:self.stackViewController.view];
    [self.stackViewController.view setFrame:self.view.bounds];
    [self.stackViewController didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews
{
	[self _updateTouchApprovalAreas];
}

#pragma mark - Public

- (id<SCStackLayouterProtocol>)layouter
{
    return [self.stackViewController layouterForPosition:(SCStackViewControllerPosition)self.position];
}

- (void)setLayouter:(id<SCStackLayouterProtocol>)layouter
{
    [self.stackViewController registerLayouter:layouter forPosition:(SCStackViewControllerPosition)self.position animated:NO];
}

- (NSArray *)viewControllers
{
    return [[NSArray arrayWithObject:self.rootViewController] arrayByAddingObjectsFromArray:[self.stackViewController viewControllersForPosition:(SCStackViewControllerPosition)self.position]];
}

- (NSArray *)visibleViewControllers
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [self.stackViewController isViewControllerVisible:evaluatedObject];
    }];
    
    return [self.viewControllers filteredArrayUsingPredicate:predicate];
}

- (CGFloat)visiblePercentageForViewController:(UIViewController *)viewController
{
	return [self.stackViewController visiblePercentageForViewController:viewController];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
	NSAssert(viewController != nil, @"Trying to push a nil view controller");
	
	if([self.viewControllers containsObject:viewController]) {
		NSLog(@"Trying to push an already pushed view controller");
		[self.stackViewController navigateToViewController:viewController animated:animated completion:completion];
		return;
	}
	
	[self popToViewController:self.visibleViewControllers.lastObject animated:NO completion:^{
		[viewController.view setFrame:self.view.bounds];
		[self.stackViewController pushViewController:viewController
										  atPosition:(SCStackViewControllerPosition)self.position
											  unfold:YES
											animated:animated
										  completion:^{
											  
                                              [self _updateTouchApprovalAreas];
											  
											  if(completion) {
												  completion();
											  }
										  }];
	}];
}

- (void)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if([[self.viewControllers lastObject] isEqual:self.rootViewController]) {
        if(completion) {
            completion();
        }
		
        return;
    }
	
	[self popToViewController:self.visibleViewControllers.lastObject animated:NO completion:^{
		[self.stackViewController popViewControllerAtPosition:(SCStackViewControllerPosition)self.position
													 animated:animated
												   completion:^{
													   
													   [self _updateTouchApprovalAreas];
													   
													   if(completion) {
														   completion();
													   }
												   }];
	}];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if([[self.viewControllers lastObject] isEqual:viewController]) {
        if(completion) {
            completion();
        }
		
        return;
    }
	
    NSRange controllersToPopRange = NSMakeRange([self.viewControllers indexOfObject:viewController] + 1, self.viewControllers.count - [self.viewControllers indexOfObject:viewController] - 1);
    NSArray *controllersToPop = [self.viewControllers subarrayWithRange:controllersToPopRange];
	
	void(^cleanup)(void) = ^{
		[self _updateTouchApprovalAreas];
		
		if(completion) {
			completion();
		}
	};
	
	if([self.visibleViewControllers.lastObject isEqual:viewController]) {
		for(UIViewController *controller in controllersToPop) {
			[self.stackViewController popViewController:controller animated:NO completion:nil];
		}
		
		cleanup();
		return;
	}
	
    for(UIViewController *controller in controllersToPop) {
        if([controller isEqual:[self.visibleViewControllers lastObject]]) {
			[self.stackViewController navigateToViewController:controller animated:NO completion:^{
				[self.stackViewController popViewController:controller animated:YES completion:cleanup];
			}];
			
            return;
        }
		
        [self.stackViewController popViewController:controller animated:NO completion:nil];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self popToViewController:self.rootViewController animated:animated completion:completion];
}

- (UIGestureRecognizer *)interactiveGestureRecognizer
{
	return self.stackViewController.scrollView.panGestureRecognizer;
}

#pragma mark - SCStackViewControllerDelegate

- (void)stackViewController:(SCStackViewController *)stackViewController didShowViewController:(UIViewController *)controller position:(SCStackViewControllerPosition)position
{
    if([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:)]) {
        [self.delegate navigationController:self didShowViewController:controller];
    }
}

- (void)stackViewController:(SCStackViewController *)stackViewController didHideViewController:(UIViewController *)controller position:(SCStackViewControllerPosition)position
{
    if([self.delegate respondsToSelector:@selector(navigationController:didHideViewController:)]) {
        [self.delegate navigationController:self didHideViewController:controller];
    }
}

- (void)stackViewController:(SCStackViewController *)stackViewController didNavigateToOffset:(CGPoint)offset
{
	if([self.delegate respondsToSelector:@selector(navigationController:didNavigateToOffset:)]) {
		[self.delegate navigationController:self didNavigateToOffset:offset];
	}
}

#pragma mark - Properties and fowarding

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.stackViewController;
}

#pragma mark - Private

- (void)_updateTouchApprovalAreas
{
	if(self.viewControllers.count == 0) {

        for(SCScrollViewTouchApprovalArea *approvalArea in self.stackViewController.scrollView.touchApprovalAreas) {
            [self.stackViewController.scrollView removeTouchApprovalArea:approvalArea];
        }
		return;
	}
	
	if(self.allowedInteractiveGestureOperations == SCNavigationControllerOperationNone) {
		return;
	}

    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if(self.allowedInteractiveGestureOperations & SCNavigationControllerOperationPop) {
            SCScrollViewTouchApprovalArea *approvalArea = [[SCScrollViewTouchApprovalArea alloc] init];
            
            CGRect frame = CGRectMake(CGRectGetWidth(self.view.bounds) * idx, 0.0f, self.interactiveGestureTriggerAreaWidth, CGRectGetHeight(self.view.bounds));
            [approvalArea setPath:[UIBezierPath bezierPathWithRect:frame]];
            
            [self.stackViewController.scrollView addTouchApprovalArea:approvalArea];
        }
        
        if(self.allowedInteractiveGestureOperations & SCNavigationControllerOperationPush) {
            SCScrollViewTouchApprovalArea *approvalArea = [[SCScrollViewTouchApprovalArea alloc] init];
            
            CGRect frame = CGRectMake(CGRectGetWidth(self.view.bounds) * (idx + 1) - self.interactiveGestureTriggerAreaWidth, 0.0f, self.interactiveGestureTriggerAreaWidth, CGRectGetHeight(self.view.bounds));
            [approvalArea setPath:[UIBezierPath bezierPathWithRect:frame]];
            
            [self.stackViewController.scrollView addTouchApprovalArea:approvalArea];
        }
    }];
}

@end
