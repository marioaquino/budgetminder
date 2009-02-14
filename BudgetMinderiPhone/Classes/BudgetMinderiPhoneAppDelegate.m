//
//  BudgetMinderiPhoneAppDelegate.m
//  BudgetMinderiPhone
//
//  Created by Mario Aquino on 2/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BudgetMinderiPhoneAppDelegate.h"
#import "RootViewController.h"

@implementation BudgetMinderiPhoneAppDelegate


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
