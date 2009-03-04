//
//  BudgetMinderPluginView.m
//  BudgetMinderPlugin
//
//  Created by Mario Aquino on 2/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BudgetMinderPlugin.h"

/* Prefix for all methods and instance variables that will be exposed in the widget */
NSString *const kJSSelectorPrefix = @"js_";

@implementation BudgetMinderPlugin

@synthesize model;

#pragma mark -
#pragma mark Functions Called by JavaScript

/*
 The plug-in adds a "js" to the beginning of any method that will be exposed to JavaScript. 
 The Web Kit's webScriptNameForSelector method returns friendly names for these exposed Objective-C methods.
 */



#pragma mark -
#pragma mark WidgetPlugin methods 
/*
 This method is called before the widgetÕs HTML page is fully loaded. 
 */
- (id)initWithWebView:(WebView*)webView
{
	self = [super init];
	return self;
}

/*
 Indicates what instance variables should be shared with JavaScript. This method should return
 YES for all instance variables with the "js" prefix and NO otherwise.
 */
+ (BOOL)isKeyExcludedFromWebScript:(const char *)name
{
	NSString* keyName = [[[NSString alloc] initWithUTF8String: name] autorelease];
	return !([ keyName hasPrefix:kJSSelectorPrefix]);
}

/*
 Provides mapping between Objective-C and JavaScript instance variable names. All Objective-C instance variables 
 will be used in JavaScript without the "js" prefix. For instance, js_uid will be called as uid in JavaScript.
 */
+ (NSString *)webScriptNameForKey:(const char *)name
{
    NSString* keyName = [[[NSString alloc] initWithUTF8String: name] autorelease];
	if ([ keyName hasPrefix:kJSSelectorPrefix] && ([ keyName length] > [kJSSelectorPrefix length]))
	{
		return [keyName substringFromIndex:[kJSSelectorPrefix length]];
	}
	return nil;
}


#pragma mark -
#pragma mark WebScripting methods 
/*
 This method provides a bridge between Objective-C and JavaScript. It creates a JavaScript object referencing 
 the plug-in, which can be used by the widget. This allows the plug-in to be called from JavaScript using 
 <plugInName>, where plugInName is the chosen plug-in name. 
 */
- (void)windowScriptObjectAvailable:(WebScriptObject*)scriptObject
{
    /* According to this statement, our plug-in will be called as RemindersPlugIn from JavaScript */
	[scriptObject setValue:self forKey:@"BudgetMinderPlugin"];
	webScriptObject = scriptObject;
	[webScriptObject retain];
}



/*
 Provides mapping between Objective-C and JavaScript method names. All Objective-C functions will be used in JavaScript
 without the "js" prefix. For instance, js_calendarToDoItems will be called as calendarToDoItems in JavaScript.
 */
+ (NSString *)webScriptNameForSelector:(SEL)aSelector 
{
	NSString* selectorName = NSStringFromSelector(aSelector);
	if ([selectorName hasPrefix:kJSSelectorPrefix] && ([selectorName length] > [kJSSelectorPrefix length]))
	{
		return [[[selectorName substringFromIndex:[kJSSelectorPrefix length]] componentsSeparatedByString: @":"] objectAtIndex: 0];
	}
	return nil;
}



/*
 Determines what methods can be called by JavaSript. This method should return YES for all methods with the "js" prefix 
 and NO otherwise.
 */
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector 
{
	return !([NSStringFromSelector(aSelector) hasPrefix:kJSSelectorPrefix]);
}



@end