//
//  BudgetWatchPluginViewTest.m
//  BudgetMinder
//
//  Created by Mario Aquino on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#import "BudgetMinderPluginView.h"

@interface BudgetMinderPluginViewTest : SenTestCase
{
	BudgetMinderPluginView* view;
}

@end

@implementation BudgetMinderPluginViewTest
- (void) setUp
{
	NSDictionary* dict = [[NSDictionary alloc]init];
	view = (BudgetMinderPluginView*)[BudgetMinderPluginView plugInViewWithArguments:dict];
}

- (void) testModelProperty
{
	NSObject<BudgetMinderModel>* model = [OCMockObject mockForProtocol: @protocol(BudgetMinderModel)];
	view.model = model;
	STAssertEqualObjects(model, view.model, nil);
}

@end
