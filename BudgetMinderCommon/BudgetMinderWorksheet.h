//
//  BudgetMinderWorksheet.h
//  BudgetWatchPlugin
//
//  Created by David Giovannini on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BudgetMinderModel.h"
#import "GDataSpreadsheet.h"

@protocol BudgetMinderWorksheetDelegate

- (void) worksheetFinishedLoading;
- (void) worksheetError: (NSError*) error;

@end

@interface BudgetMinderWorksheet : NSObject<BudgetMinderModel> {
	id delegate;
	NSString* user;
	NSString* password;
	
	GDataServiceGoogleSpreadsheet* service;
	GDataFeedBase* entryFeed;
}

@property (nonatomic, retain) NSString* user;
@property (nonatomic, retain) NSString* password;

+ (BudgetMinderWorksheet*) newUsingDelegate: (id) theDelegate;

- (void) login;

@end
