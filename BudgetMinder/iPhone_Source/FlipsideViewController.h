//
//  FlipsideViewController.h
//  BudgetMinder
//
//  Created by David Giovannini on 1/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BudgetMinderWorksheet;

@interface FlipsideViewController : UIViewController {
	UITextField* user;
	UITextField* password;
}

// No bindings on iPhone!!!
@property (nonatomic, retain) IBOutlet UITextField* user;
- (IBAction) userChanged: (id) sender;
@property (nonatomic, retain) IBOutlet UITextField* password;
- (IBAction) passwordChanged: (id) sender;

@end
