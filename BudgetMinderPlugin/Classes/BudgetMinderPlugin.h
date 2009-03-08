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

@interface BudgetMinderPlugin : NSObject
{
	NSObject<BudgetMinderModel>* model;
	/* Allow us to call JavaScript functions from our plug-in */
	WebScriptObject *webScriptObject; 
}

-(NSString *)js_FeedMe:(NSString *)food;


@property (retain, nonatomic) NSObject<BudgetMinderModel>* model;

@end
