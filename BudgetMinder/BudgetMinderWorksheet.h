//
//  BudgetMinderWorksheet.h
//  BudgetWatchPlugin
//
//  Created by David Giovannini on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GDataSpreadsheet.h"

@protocol BudgetMinderWorksheetDelegate

- (void) finishedLoading;
- (void) onError: (NSError*) error;

@end

@interface BudgetMinderWorksheet : NSObject {
	id delegate;
	GDataServiceGoogleSpreadsheet* service;
	GDataFeedBase* entryFeed;
}

+ (BudgetMinderWorksheet*) newWithUser: (NSString*) user andPassword: (NSString*) password usingDelegate: (id) theDelegate;

- (void) addExpense: (float) expense;
- (void) clear;
- (void) save;

@property (nonatomic, readonly) double currentValue;
@property (nonatomic, readonly) double remaining;
@property (nonatomic, readonly) double percentUsed;
@property (nonatomic) double budget;
@property (nonatomic) double cycleEndDate;

@end
