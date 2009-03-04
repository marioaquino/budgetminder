//
//  BudgetWatchPluginViewTest.m
//  BudgetMinder
//
//  Created by Mario Aquino on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#import "BudgetMinderPlugin.h"

@interface BudgetMinderPluginTest : SenTestCase
{
	BudgetMinderPlugin* plugin;
}

@end

@implementation BudgetMinderPluginTest
- (void) setUp
{
	plugin = [[BudgetMinderPlugin alloc] initWithWebView:nil];
}

- (void) testModelProperty
{
	NSObject<BudgetMinderModel>* model = [OCMockObject mockForProtocol: @protocol(BudgetMinderModel)];
	plugin.model = model;
	STAssertEqualObjects(model, plugin.model, nil);
}

@end
