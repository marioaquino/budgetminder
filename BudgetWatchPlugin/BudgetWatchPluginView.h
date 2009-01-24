//
//  BudgetWatchPluginView.h
//  BudgetWatchPlugin
//
//  Created by Mario Aquino on 1/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BudgetWatchWorksheet.h"

@interface BudgetWatchPluginView : NSView <WebPlugInViewFactory, BudgetWatchSpreadsheetDelegate>
{
	BudgetWatchWorksheet* workSheet;
}

@end
