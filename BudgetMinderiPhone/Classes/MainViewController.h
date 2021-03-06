//
//  MainViewController.h
//  BudgetMinder
//
//  Created by David Giovannini on 1/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BudgetMinderWorksheet.h"

@interface MainViewController : UIViewController<BudgetMinderWorksheetDelegate> {
    BudgetMinderWorksheet* model;
}

@property (nonatomic, retain) IBOutlet BudgetMinderWorksheet* model;

@end
