//
//  BudgetMinderAppDelegate.m
//  BudgetMinder
//
//  Created by David Giovannini on 1/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BudgetMinderAppDelegate.h"
#import "RootViewController.h"

@implementation BudgetMinderAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
