//
//  MainViewController.m
//  BudgetMinder
//
//  Created by David Giovannini on 1/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "BudgetMinderWorksheet.h"

@implementation MainViewController

@synthesize model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {		
		NSUserDefaults* setttings = [NSUserDefaults standardUserDefaults];
		[setttings setObject: @"lw.mario.test.account@gmail.com" forKey: @"user"];
		[setttings setObject: @"lwchattesting" forKey: @"password"];
		
		self.model = [BudgetMinderWorksheet newUsingDelegate: self];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	NSUserDefaults* setttings = [NSUserDefaults standardUserDefaults];
	model.user = [setttings objectForKey: @"user"];
	model.password = [setttings objectForKey: @"password"];
	[model login];
}

- (void) worksheetFinishedLoading
{
	UIAlertView* alert = [[UIAlertView alloc] 
						  initWithTitle: @"Goggle is pleased." 
						  message: @"We have a spreadsheet" 
						  delegate: nil
						  cancelButtonTitle: @"Yep" 
						  otherButtonTitles: nil];
	[alert show];
}

- (void) worksheetError: (NSError*) error
{
	UIAlertView* alert = [[UIAlertView alloc] 
				initWithTitle: @"Goggle is not pleased." 
				message: error.localizedDescription 
				delegate: nil
				cancelButtonTitle: @"Yep" 
				otherButtonTitles: nil];
	[alert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
