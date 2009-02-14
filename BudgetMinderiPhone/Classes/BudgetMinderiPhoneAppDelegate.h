//
//  BudgetMinderiPhoneAppDelegate.h
//  BudgetMinderiPhone
//
//  Created by Mario Aquino on 2/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface BudgetMinderiPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

