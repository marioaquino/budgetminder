//
//  BudgetWatchPluginViewTest.m
//  BudgetMinder
//
//  Created by Mario Aquino on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BudgetWatchPluginViewTest.h"


@implementation BudgetWatchPluginViewTest

- (void) testFoo 
{
	NSNumber* theObj = [NSNumber numberWithInt:1];
   	NSNumber* theObj2 = [NSNumber numberWithInt:1];
	
	STAssertEqualObjects(theObj, theObj2, @"Objects were not equal. Value 1: %d Value 2: %d", [theObj intValue], [theObj2 intValue]);
}


@end
