//
//  SCAppDelegate.m
//  SCNavigationController
//
//  Created by Stefan Ceriu on 09/11/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCAppDelegate.h"
#import "SCRootViewController.h"

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setRootViewController:[[SCRootViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
