//
//  BudgetMinderModel.h
//  BudgetMinder
//
//  Created by David Giovannini on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol BudgetMinderModel

- (void) addExpense: (float) expense;
- (void) clear;
- (void) save;

@property (nonatomic, readonly) double currentValue;
@property (nonatomic, readonly) double remaining;
@property (nonatomic, readonly) double percentUsed;
@property (nonatomic) double budget;
@property (nonatomic) double cycleEndDate;

@end
