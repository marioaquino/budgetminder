//
//  RootViewController.h
//  BudgetMinder
//
//  Created by David Giovannini on 1/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class FlipsideViewController;

@interface RootViewController : UIViewController {
    UIButton *infoButton;
    MainViewController *mainViewController;
    FlipsideViewController *flipsideViewController;
    UINavigationBar *flipsideNavigationBar;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UINavigationBar *flipsideNavigationBar;
@property (nonatomic, retain) FlipsideViewController *flipsideViewController;

- (IBAction)toggleView;

@end
