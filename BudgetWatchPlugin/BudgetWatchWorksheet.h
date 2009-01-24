//
//  BudgetWatchWorksheet.h
//  BudgetWatchPlugin
//
//  Created by David Giovannini on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GDataSpreadsheet.h"

@protocol BudgetWatchSpreadsheetDelegate

- (void) finishedLoading;
- (void) onError: (NSError*) error;

@end

@interface BudgetWatchWorksheet : NSObject {
	id delegate;
	GDataServiceGoogleSpreadsheet* service;
	GDataFeedBase* entryFeed;
}

+ (BudgetWatchWorksheet*) newWithUser: (NSString*) user andPassword: (NSString*) password usingDelegate: (id) theDelegate;

- (void) addExpense: (float) expense;
- (void) clear;
- (void) save;

@property (nonatomic, readonly) double currentValue;
@property (nonatomic, readonly) double remaining;
@property (nonatomic, readonly) double percentUsed;
@property (nonatomic) double budget;
@property (nonatomic) double cycleEndDate;

@end
