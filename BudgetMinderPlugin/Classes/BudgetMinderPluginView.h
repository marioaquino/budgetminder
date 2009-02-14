//
//  BudgetMinderPluginView.h
//  BudgetMinderPlugin
//
//  Created by Mario Aquino on 2/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "BudgetMinderModel.h"

@interface BudgetMinderPluginView : NSView <WebPlugInViewFactory>
{
	NSObject<BudgetMinderModel>* model;
}

@property (retain, nonatomic) NSObject<BudgetMinderModel>* model;

@end
