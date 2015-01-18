//
//  SCRootViewController.m
//  SCNavigationController
//
//  Created by Stefan Ceriu on 09/11/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCRootViewController.h"

#import "SCNavigationController.h"

#import "SCMainViewController.h"

#import "UIColor+RandomColors.h"

#import "SCStackLayouter.h"
#import "SCParallaxStackLayouter.h"
#import "SCSlidingStackLayouter.h"
#import "SCGoogleMapsStackLayouter.h"
#import "SCMerryGoRoundStackLayouter.h"
#import "SCResizingStackLayouter.h"

#import "SCStackViewController.h"
#import "SCResizingStackLayouter.h"

@interface SCRootViewController () <SCMainViewControllerDelegate, SCNavigationControllerDelegate>

@property (nonatomic, strong) SCNavigationController *navigationController;

@property (nonatomic, assign) SCEasingFunctionType selectedEasingFunctionType;

@end

@implementation SCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SCMainViewController *rootViewController = [[SCMainViewController alloc] init];
    [rootViewController setDelegate:self];
    [rootViewController.view setBackgroundColor:[UIColor randomColor]];
    
    self.selectedEasingFunctionType = SCEasingFunctionTypeSineEaseInOut;
    
    self.navigationController = [[SCNavigationController alloc] initWithRootViewController:rootViewController];
    [self.navigationController setDelegate:self];
    
    [self addChildViewController:self.navigationController];
    [self.view addSubview:self.navigationController.view];
    [self.navigationController didMoveToParentViewController:self];
	
    //Optional properties
    //[self.navigationController setBounces:NO];
    //[self.navigationController setScrollEnabled:NO];
    //[self.navigationController setShowsScrollIndicators:YES];
    //[self.navigationController setMinimumNumberOfTouches:1];
    //[self.navigationController setMaximumNumberOfTouches:1];
    //[self.navigationController setTouchRefusalArea:nil];
}

#pragma mark - SCMainViewControllerDelegate

- (void)mainViewControllerDidChangeLayouterType:(SCMainViewController *)mainViewController
{
    static NSDictionary *typeToLayouter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeToLayouter = (@{@(SCStackLayouterTypePlain)         : [SCStackLayouter class],
                            @(SCStackLayouterTypeSliding)       : [SCSlidingStackLayouter class],
                            @(SCStackLayouterTypeParallax)      : [SCParallaxStackLayouter class],
                            @(SCStackLayouterTypeGoogleMaps)    : [SCGoogleMapsStackLayouter class],
                            @(SCStackLayouterTypeMerryGoRound)  : [SCMerryGoRoundStackLayouter class]});
    });
    
    id<SCStackLayouterProtocol> layouter = [[typeToLayouter[@(mainViewController.layouterType)] alloc] init];
    [self.navigationController setLayouter:layouter];
}

- (void)mainViewControllerDidChangeAnimationType:(SCMainViewController *)mainViewController
{
    [self.navigationController setEasingFunction:[SCEasingFunction easingFunctionWithType:mainViewController.easingFunctionType]];
    self.selectedEasingFunctionType = mainViewController.easingFunctionType;
}

- (void)mainViewControllerDidChangeAnimationDuration:(SCMainViewController *)mainViewController
{
    [self.navigationController setAnimationDuration:mainViewController.duration];
}

- (void)mainViewControllerDidRequestPush:(SCMainViewController *)mainViewController
{
    SCMainViewController *viewController = [[SCMainViewController alloc] init];
    [viewController setDelegate:self];
    [viewController.view setBackgroundColor:[UIColor randomColor]];
    
    [self.navigationController pushViewController:viewController animated:YES completion:nil];
}

- (void)mainViewControllerDidRequestPop:(SCMainViewController *)mainViewController
{
	[self.navigationController popViewControllerAnimated:YES completion:nil];
}

- (void)mainViewControllerDidRequestPopToRoot:(SCMainViewController *)mainViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES completion:nil];
}

#pragma mark - SCNavigationControllerDelegate

- (void)navigationController:(SCNavigationController *)navigationController didShowViewController:(SCMainViewController *)controller
{
    [controller.pageNumberLabel setText:[NSString stringWithFormat:@"Page %ld", (unsigned long)index]];
    
    [controller setEasingFunctionType:self.selectedEasingFunctionType];
    [controller setDuration:self.navigationController.animationDuration];
    
    static NSDictionary *layouterToType;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        layouterToType = (@{NSStringFromClass([SCStackLayouter class])              : @(SCStackLayouterTypePlain),
                            NSStringFromClass([SCSlidingStackLayouter class])       : @(SCStackLayouterTypeSliding),
                            NSStringFromClass([SCParallaxStackLayouter class])      : @(SCStackLayouterTypeParallax),
                            NSStringFromClass([SCGoogleMapsStackLayouter class])    : @(SCStackLayouterTypeGoogleMaps),
                            NSStringFromClass([SCMerryGoRoundStackLayouter class])  : @(SCStackLayouterTypeMerryGoRound)});
    });
    
    [controller setLayouterType:(SCStackLayouterType)[layouterToType[NSStringFromClass([self.navigationController.layouter class])] unsignedIntegerValue]];
}

@end
