//
//  BudgetMinderWorksheet.m
//  BudgetWatchPlugin
//
//  Created by David Giovannini on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BudgetMinderWorksheet.h"

@interface BudgetMinderWorksheet (private)

- (id) initWithUser: (NSString*) user andPassword: (NSString*) password  usingDelegate: (id) theDelegate;
- (void) spreadsheetsTicket: (GDataServiceTicket*) ticket finishedWithFeed: (GDataFeedSpreadsheet*) object;
- (void) spreadsheetsTicket: (GDataServiceTicket*) ticket failedWithError: (NSError*) error;
- (void) worksheetsTicket: (GDataServiceTicket*) ticket finishedWithFeed: (GDataFeedWorksheet*) object;
- (void) worksheetsTicket: (GDataServiceTicket*) ticket failedWithError:(NSError*) error;
- (void) entriesTicket: (GDataServiceTicket*) ticket finishedWithEntries: (GDataFeedBase*) object;
- (void) entriesTicket: (GDataServiceTicket*) ticket failedWithError: (NSError*) error;

@end

@implementation BudgetMinderWorksheet

+ (BudgetMinderWorksheet*) newWithUser: (NSString*) user andPassword: (NSString*) password  usingDelegate: (id) theDelegate
{
	return [[BudgetMinderWorksheet alloc] initWithUser: user andPassword: password usingDelegate: theDelegate];
}

- (id) initWithUser: (NSString*) user andPassword: (NSString*) password  usingDelegate: (id) theDelegate
{
	[super init];
	delegate = theDelegate;
	service = [[GDataServiceGoogleSpreadsheet alloc] init];
	[service setUserAgent: @"Melvin-BudgetMinder-1.0"];
	[service setUserCredentialsWithUsername: user password: password];
	
	NSURL* feedURL = [NSURL URLWithString: kGDataGoogleSpreadsheetsPrivateFullFeed];
	[service fetchSpreadsheetFeedWithURL: feedURL
						delegate: self
						didFinishSelector: @selector(spreadsheetsTicket:finishedWithFeed:)
						didFailSelector: @selector(spreadsheetsTicket:failedWithError:)];
	return self;
}

- (void) spreadsheetsTicket: (GDataServiceTicket*) ticket finishedWithFeed: (GDataFeedSpreadsheet*) object
{
	NSArray* spreadsheets = [object entries];
	if (spreadsheets != nil && spreadsheets.count > 0 )
	{
		GDataEntrySpreadsheet* spreadsheet = [spreadsheets objectAtIndex: 0];
		NSURL* feedURL = [spreadsheet.worksheetsLink URL];
		if (feedURL)
		{
			[service fetchSpreadsheetFeedWithURL: feedURL
						delegate: self
						didFinishSelector: @selector(worksheetsTicket:finishedWithEntries:)
						didFailSelector: @selector(worksheetsTicket:failedWithError:)];
		}
	}
	else
	{
		[delegate onError: nil];
	}
}

- (void) spreadsheetsTicket: (GDataServiceTicket*) ticket failedWithError: (NSError*) error {
	[delegate onError: error];	
}

- (void) worksheetsTicket: (GDataServiceTicket *)ticket finishedWithEntries:(GDataFeedWorksheet*) object {
	NSArray* worksheets = [object entries];
	if (worksheets != nil && worksheets.count > 0)
	{
		GDataEntryWorksheet* worksheet = [worksheets objectAtIndex: 0];
		bool cellsNotList = false;
		NSURL *feedURL = (cellsNotList ? worksheet.cellsLink : worksheet.listLink).URL;
		if (feedURL)
		{
			[service fetchSpreadsheetFeedWithURL: feedURL
					delegate: self
					didFinishSelector: @selector(entriesTicket:finishedWithEntries:)
					didFailSelector: @selector(entriesTicket:failedWithError:)];
		}
	}
	else
	{
		[delegate onError: nil];
	}
} 

- (void) worksheetsTicket: (GDataServiceTicket *)ticket failedWithError: (NSError*) error
{
	[delegate onError: error];
}

- (void) entriesTicket: (GDataServiceTicket*) ticket finishedWithEntries: (GDataFeedBase*) object
{	
	entryFeed = [object retain];
	[delegate finishedLoading];
} 

- (void) entriesTicket: (GDataServiceTicket*) ticket failedWithError: (NSError*) error
{
	[delegate onError: error];	
}

- (void) addExpense: (float) expense
{
}

- (void) clear
{
}


- (void) save
{
}

- (double) currentValue
{
	return 0.0;
}

- (double) remaining
{
	return 0.0;
}

- (double) percentUsed
{
	return 0.0;
}

- (double) budget
{
	return 0.0;
}

- (void) setBudget: (double) budget
{
}

- (double) cycleEndDate
{
	return 0.0;
}

- (void) setCycleEndDate: (double) cycleEndDate
{
}

@end

/*
 require "rubygems"
 require "google_spreadsheet"
 
 class BudgetMinder
 
 def initialize
 session = GoogleSpreadsheet.login(*user_and_pass)
 spreadsheet = session.spreadsheets("title" => "BudgetMinder").first
 @ws = spreadsheet.worksheets[0]
 end
 
 def add_expense(value)
 next_row = ws.num_rows + 1
 ws[next_row, 2] = Date.today.to_s
 ws[next_row, 3] = value
 ws.synchronize
 end
 
 def current_value
 ws[2, 1]
 end
 
 def clear
 2.upto(ws.num_rows) do |row| 
 ws[row, 2] = ''
 ws[row, 3] = ''
 end
 ws.synchronize
 end
 
 def budget
 ws[2, 4]
 end
 
 def budget=(value)
 ws[2, 4] = value
 ws.synchronize
 end
 
 def remaining
 ws[2, 5]
 end
 
 def cycle_end_date
 ws[2, 6]
 end
 
 def cycle_end_date=(value)
 ws[2, 6] = value
 end
 
 def save
 ws.synchronize
 end
 
 def days_until_end_of_cycle
 (Date.parse(cycle_end_date) - Date.today).to_i
 end
 
 def percent_used
 ws[2, 7]
 end
 
 private
 attr_reader :ws
 
 def parse(lookup, pattern)
 $1 if lookup.find { |s| s =~ pattern }
 end
 
 def user_and_pass
 # Redirect stderr (where password is written to), to stdout
 lookup = `security 2>&1 find-generic-password -gs BudgetMinder`
 
 username_pattern = /^[\s]+"acct"<blob>="(.*)"$/
 password_pattern = /^password: "(.*)"$/
 
 username = parse lookup, username_pattern
 password = parse lookup, password_pattern
 [username, password]
 end
 end
 */
