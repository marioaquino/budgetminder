/* Copyright (c) 2007 Google Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

//
//  GDataQueryTest.m
//

#import "GData.h"
#import "GDataQueryTest.h"

#define typeof __typeof__ // fixes http://www.brethorsting.com/blog/2006/02/stupid-issue-with-ocunit.html

@implementation GDataQueryTest

- (void)testGDataCalendarQuery {
  
  NSURL* feedURL = [NSURL URLWithString:@"http://www.google.com/calendar/feeds/userID/private/basic"];
  
  GDataDateTime* dateTime1 = [GDataDateTime dateTimeWithRFC3339String:@"2006-03-29T07:35:59.000Z"];
  GDataDateTime* dateTime2 = [GDataDateTime dateTimeWithRFC3339String:@"2006-03-30T07:35:59.000Z"];
  GDataDateTime* dateTime3 = [GDataDateTime dateTimeWithRFC3339String:@"2006-04-29T07:35:59.000Z"];
  GDataDateTime* dateTime4 = [GDataDateTime dateTimeWithRFC3339String:@"2007-06-25T13:37:54.146+07:00"];
  
  // test query with feed URL but no params
  GDataQuery* query1 = [GDataQuery queryWithFeedURL:feedURL];
  NSURL* resultURL1 = [query1 URL];
  STAssertEqualObjects(resultURL1, feedURL, @"Unadorned feed URL is not preserved by GDataQuery");

  // test query with params but no categories
  GDataQuery* query2 = [GDataQuery queryWithFeedURL:feedURL];
  [query2 setStartIndex:10];
  [query2 setMaxResults:20];
  [query2 setFullTextQueryString:@"Darcy"];
  [query2 setAuthor:@"Fred Flintstone"];
  [query2 setOrderBy:@"random"];
  [query2 setIsAscendingOrder:YES];
  [query2 setPublishedMinDateTime:dateTime1];
  [query2 setPublishedMaxDateTime:dateTime2];
  [query2 setUpdatedMinDateTime:dateTime3];
  [query2 setUpdatedMaxDateTime:dateTime4];
  [query2 addCustomParameterWithName:@"Fred" value:@"Barney"];
  [query2 addCustomParameterWithName:@"Wilma" value:@"Betty"];
  
  NSURL* resultURL2 = [query2 URL];
  NSString *expected2 = @"http://www.google.com/calendar/feeds/userID/private/basic"
    "?q=Darcy&author=Fred+Flintstone&orderby=random&sortorder=ascending"
    "&updated-min=2006-04-29T07%3A35%3A59Z&updated-max=2007-06-25T13%3A37%3A54%2B07%3A00"
    "&published-min=2006-03-29T07%3A35%3A59Z&published-max=2006-03-30T07%3A35%3A59Z"
    "&start-index=10&max-results=20&Fred=Barney&Wilma=Betty";
  STAssertEqualObjects([resultURL2 absoluteString], expected2, @"Parameter generation error");
  
  GDataCategoryFilter *categoryFilter = [GDataCategoryFilter categoryFilter];
  [categoryFilter addCategory:[GDataCategory categoryWithScheme:@"http://schemas.google.com/g/2005#kind" 
                                                           term:@"http://schemas.google.com/g/2005#event"]];
  [categoryFilter addCategory:[GDataCategory categoryWithScheme:@"MyScheme2" 
                                                           term:@"MyTerm2"]];
  [categoryFilter addExcludeCategory:[GDataCategory categoryWithScheme:nil
                                                                  term:@"MyTerm3"]];

  // test a query with categories but no params
  GDataQuery* query3 = [GDataQuery queryWithFeedURL:feedURL];
  [query3 addCategoryFilter:categoryFilter];
  NSURL* resultURL3 = [query3 URL];
 
  NSString* expected3 = @"http://www.google.com/calendar/feeds/userID/private/basic/"
    "-/%7Bhttp://schemas.google.com/g/2005%23kind%7Dhttp://schemas.google.com/g/2005%23event%7C%7BMyScheme2%7DMyTerm2%7C-MyTerm3";
  STAssertEqualObjects([resultURL3 absoluteString], expected3, @"Category filter generation error");
  
  
  // finally, add the previous category filter and another category filter
  // to the second query's parameters
  GDataCategoryFilter *categoryFilter2 = [GDataCategoryFilter categoryFilter];
  [categoryFilter2 addCategory:[GDataCategory categoryWithScheme:nil term:@"Zonk4"]];

  [query2 addCategoryFilter:categoryFilter];
  [query2 addCategoryFilter:categoryFilter2];
  
  NSURL* resultURL2a = [query2 URL];
  NSString *expected2a = @"http://www.google.com/calendar/feeds/userID/private/basic/"
    "-/%7Bhttp://schemas.google.com/g/2005%23kind%7Dhttp://schemas.google.com/g/2005%23event%7C%7BMyScheme2%7DMyTerm2%7C-MyTerm3/Zonk4"
    "?q=Darcy&author=Fred+Flintstone&orderby=random&sortorder=ascending"
    "&updated-min=2006-04-29T07%3A35%3A59Z&updated-max=2007-06-25T13%3A37%3A54%2B07%3A00&published-min=2006-03-29T07%3A35%3A59Z"
    "&published-max=2006-03-30T07%3A35%3A59Z&start-index=10&max-results=20&Fred=Barney&Wilma=Betty";
    
  STAssertEqualObjects([resultURL2a absoluteString], expected2a, @"Category filter generation error");
  //NSLog(@"======+++++> %@", [[resultURL2a absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
  
  //
  // test a calendar query
  //
  GDataQueryCalendar* queryCal = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
  [queryCal setStartIndex:10];
  [queryCal setMaxResults:20];
  [queryCal setMinimumStartTime:dateTime1];
  [queryCal setMaximumStartTime:dateTime2];
  
  NSURL* resultURLC1 = [queryCal URL];
  NSString *expectedC1 = @"http://www.google.com/calendar/feeds/userID/private/basic?"
    "start-index=10&max-results=20&start-max=2006-03-30T07%3A35%3A59Z&start-min=2006-03-29T07%3A35%3A59Z";
  STAssertEqualObjects([resultURLC1 absoluteString], expectedC1, @"Query error");
  
  GDataQueryCalendar* queryCal2 = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
  [queryCal2 setRecurrenceExpansionStartTime:dateTime1];
  [queryCal2 setRecurrenceExpansionEndTime:dateTime1];
  [queryCal2 setShouldQueryAllFutureEvents:YES];
  [queryCal2 setShouldExpandRecurrentEvents:YES];
  [queryCal2 setCurrentTimeZoneName:@"America/Los Angeles"];
  
  NSURL* resultURLC2 = [queryCal2 URL];
  NSString *expectedC2 = @"http://www.google.com/calendar/feeds/userID/private/basic?"
    "ctz=America%2FLos_Angeles&futureevents=true&"
    "recurrence-expansion-end=2006-03-29T07%3A35%3A59Z&"
    "recurrence-expansion-start=2006-03-29T07%3A35%3A59Z&singleevents=true";
  STAssertEqualObjects([resultURLC2 absoluteString], expectedC2, @"Query error");
  
}

- (void)testGDataGoogleBaseQuery {
  
  NSURL* feedURL = [NSURL URLWithString:@"http://www.google.com/base/feeds/snippets/"];
  
  GDataQueryGoogleBase* queryGB1 = [GDataQueryGoogleBase googleBaseQueryWithFeedURL:feedURL];
  [queryGB1 setIsAscendingOrder:YES];
  [queryGB1 setOrderBy:@"modification_time"];
  [queryGB1 setMaxValues:7];
  
  NSURL* resultURLGB1 = [queryGB1 URL];
  NSString *expectedGB1 = @"http://www.google.com/base/feeds/snippets/?"
    "orderby=modification_time&sortorder=ascending&max-values=7";
  STAssertEqualObjects([resultURLGB1 absoluteString], expectedGB1, @"Google Base query 1 generation error");
  
  // Try a "bq" base query
  
 GDataQueryGoogleBase* queryGB2 = [GDataQueryGoogleBase googleBaseQueryWithFeedURL:feedURL];
  [queryGB2 setGoogleBaseQuery:@"digital camera"];
  [queryGB2 setMaxResults:1];
  
  NSURL* resultURLGB2 = [queryGB2 URL];
  NSString *expectedGB2 = @"http://www.google.com/base/feeds/snippets/"
    "?max-results=1&bq=digital+camera";
  STAssertEqualObjects([resultURLGB2 absoluteString], expectedGB2, @"Google Base query 2 generation error");
}

- (void)testGDataSpreadsheetsQuery {
  
  NSURL* feedURL = [NSURL URLWithString:kGDataGoogleSpreadsheetsPrivateFullFeed];
  
  // cell feed query tests
  GDataQuerySpreadsheet* query1 = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
  [query1 setMinimumRow:3];
  [query1 setMaximumRow:7];
  [query1 setMinimumColumn:2];
  [query1 setMaximumColumn:12];
  [query1 setRange:@"A1:B2"];
  [query1 setShouldReturnEmpty:YES];
  
  NSURL* resultURL1 = [query1 URL];
  NSString *expected1 = @"http://spreadsheets.google.com/feeds/spreadsheets/private/full?"
    "max-col=12&max-row=7&min-col=2&min-row=3&range=A1%3AB2&return-empty=true";
  STAssertEqualObjects([resultURL1 absoluteString], expected1, 
                       @"Spreadsheet query 1 generation error");

  // list feed query tests
  GDataQuerySpreadsheet* query2 = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
  [query2 setSpreadsheetQuery:@"ipm<4 and hours>40"];
  [query2 setOrderBy:@"column:foostuff"];
  [query2 setIsReverseSort:YES];
  
  NSURL* resultURL2 = [query2 URL];
  NSString *expected2 = @"http://spreadsheets.google.com/feeds/spreadsheets/private/full?"
    "orderby=column%3Afoostuff&reverse=true&sq=ipm%3C4+and+hours%3E40";
  STAssertEqualObjects([resultURL2 absoluteString], expected2, 
                       @"Spreadsheet query 2 generation error");
}

- (void)testPicasaWebQuery {
  
  GDataQueryPicasaWeb *pwaQuery1;
  pwaQuery1 = [GDataQueryPicasaWeb picasaWebQueryForUserID:@"fredflintstone"
                                                   albumID:@"12345"
                                                 albumName:nil
                                                   photoID:@"987654321"];
  [pwaQuery1 setKind:kGDataPicasaWebKindPhoto];
  [pwaQuery1 setAccess:kGDataPicasaWebAccessPrivate];
  [pwaQuery1 setThumbsize:80];
  [pwaQuery1 setImageSize:32];
  [pwaQuery1 setTag:@"dog"];
  
  NSURL* resultURL1 = [pwaQuery1 URL];
  NSString *expected1 = @"http://picasaweb.google.com/data/feed/api/"
    "user/fredflintstone/albumid/12345/photoid/987654321?"
    "access=private&imgmax=32&kind=photo&tag=dog&thumbsize=80";
  STAssertEqualObjects([resultURL1 absoluteString], expected1, 
                       @"PWA query 1 generation error");
  STAssertEquals([pwaQuery1 imageSize], 32, @"image size error");
  
  GDataQueryPicasaWeb *pwaQuery2; 
  pwaQuery2 = [GDataQueryPicasaWeb picasaWebQueryForUserID:@"fredflintstone"
                                                   albumID:nil
                                                 albumName:@"froggy photos"
                                                   photoID:nil];  
  [pwaQuery2 setImageSize:kGDataPicasaWebImageSizeDownloadable];
  
  NSURL* resultURL2 = [pwaQuery2 URL];
  NSString *expected2 = @"http://picasaweb.google.com/data/feed/api/user/"
    "fredflintstone/album/froggy%20photos?imgmax=d";
  STAssertEqualObjects([resultURL2 absoluteString], expected2, 
                       @"PWA query 2 generation error");
  
  // image size special cases mapping -1 to "d" and back; test that we get back
  // -1
  STAssertEquals([pwaQuery2 imageSize], kGDataPicasaWebImageSizeDownloadable,
                 @"image size error (2)");
  
  // test the generator for photo contact feed URLs
  NSURL *contactsURL = [GDataServiceGooglePicasaWeb picasaWebContactsFeedURLForUserID:@"fred@gmail.com"];
  NSString *contactsURLString = [contactsURL absoluteString];
  NSString *expectedContactsURLString = @"http://picasaweb.google.com/data/feed/api/user/fred@gmail.com/contacts?kind=user";
  STAssertEqualObjects(contactsURLString, expectedContactsURLString, 
                       @"contacts URL error");
}

- (void)testYouTubeQuery {
  
  NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForUserID:@"fred"
                                                       userFeedID:kGDataYouTubeUserFeedIDFavorites];
  
  GDataQueryYouTube *ytQuery1;  
  ytQuery1 = [GDataQueryYouTube youTubeQueryWithFeedURL:feedURL];
  
  [ytQuery1 setVideoQuery:@"\"Fred Flintstone\""];
  [ytQuery1 setFormat:@"0,5,6"];
  [ytQuery1 setTimePeriod:kGDataYouTubePeriodThisWeek];
  [ytQuery1 setOrderBy:kGDataYouTubeOrderByRelevance];
  [ytQuery1 setRestriction:@"127.0.0.1"];
  [ytQuery1 setLanguageRestriction:@"en"];
  [ytQuery1 setLocation:@"Canada"];
  [ytQuery1 setAllowRacy:YES];
  
  NSURL* resultURL1 = [ytQuery1 URL];
  NSString *expected1 = @"http://gdata.youtube.com/feeds/api/users/fred/"
    "favorites?orderby=relevance&format=0%2C5%2C6&location=Canada&lr=en"
    "&racy=include&restriction=127.0.0.1&time=this_week"
    "&vq=%22Fred+Flintstone%22";
  STAssertEqualObjects([resultURL1 absoluteString], expected1, 
                       @"YouTube query 1 generation error");
}

- (void)testContactQuery {
  
  GDataQueryContact *query1;
  query1 = [GDataQueryContact contactQueryForUserID:@"user@gmail.com"];
  
  [query1 setGroupIdentifier:@"http://www.google.com/m8/feeds/groups/user%40gmail.com/base/6"];
  
  NSURL *resultURL1 = [query1 URL];
  NSString *expected1 = @"http://www.google.com/m8/feeds/contacts/user@gmail.com/full?group=http%3A%2F%2Fwww.google.com%2Fm8%2Ffeeds%2Fgroups%2Fuser%2540gmail.com%2Fbase%2F6";
  STAssertEqualObjects([resultURL1 absoluteString], expected1, 
                       @"Contacts query 1 generation error");
}

- (void)testFinanceQuery {
  
  NSURL *feedURL = [GDataServiceGoogleFinance portfolioFeedURLForUserID:@"user@gmail.com"];

  GDataQueryFinance *query1;
  query1 = [GDataQueryFinance financeQueryWithFeedURL:feedURL];
  
  [query1 setShouldIncludeReturns:NO];
  [query1 setShouldIncludePositions:NO];
  [query1 setShouldIncludeTransactions:NO];

  NSURL *resultURL1 = [query1 URL];
  NSString *expected1 = @"http://finance.google.com/finance/feeds/user@gmail.com/portfolios";
  STAssertEqualObjects([resultURL1 absoluteString], expected1, 
                       @"Finance query 1 generation error");
  
  GDataQueryFinance *query2;
  query2 = [GDataQueryFinance financeQueryWithFeedURL:feedURL];
  
  [query2 setShouldIncludeReturns:YES];
  [query2 setShouldIncludePositions:YES];
  [query2 setShouldIncludeTransactions:YES];
  
  NSURL *resultURL2 = [query2 URL];
  NSString *expected2 = @"http://finance.google.com/finance/feeds/user@gmail.com/portfolios?positions=true&returns=true&transactions=true";
  
  STAssertEqualObjects([resultURL2 absoluteString], expected2, 
                       @"Finance query 2 generation error");
}

- (void)testBooksQuery {

  NSURL *feedURL = [NSURL URLWithString:kGDataGoogleBooksVolumeFeed];
  GDataQueryBooks *query1 = [GDataQueryBooks booksQueryWithFeedURL:feedURL];

  [query1 setMinimumViewability:kGDataGoogleBooksMinViewabilityFull];

  NSURL *resultURL1 = [query1 URL];
  NSString *expected1 = @"http://books.google.com/books/feeds/volumes?min-viewability=full";
  STAssertEqualObjects([resultURL1 absoluteString], expected1,
                       @"Books query 1 generation error");
}

- (void)testDocsQuery {
  NSURL *feedURL = [NSURL URLWithString:kGDataGoogleDocsDefaultPrivateFullFeed];
  GDataQueryDocs *query1 = [GDataQueryDocs documentQueryWithFeedURL:feedURL];

  [query1 setTitleQuery:@"King Of Oceania"];
  [query1 setIsTitleQueryExact:YES];
  [query1 setParentFolderName:@"Major Folder"];
  [query1 setShouldShowFolders:YES];

  NSURL *resultURL1 = [query1 URL];
  NSString *expected1 = @"http://docs.google.com/feeds/documents/private/full?folder=Major+Folder&showfolders=true&title=King+Of+Oceania&title-exact=true";
  STAssertEqualObjects([resultURL1 absoluteString], expected1,
                       @"Docs query 1 generation error");
}

- (void)testURLParameterEncoding {
  
  // test all characters between 0x20 and 0x7f
  NSString *fullAsciiParam = @" !\"#$%&'()*+,-./"
    "0123456789:;<=>?@"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`"
    "abcdefghijklmnopqrstuvwxyz{|}~";
  
  // full URL encoding leaves +, =, and other URL-legal symbols intact
  NSString *fullEncoded = @"%20!%22%23$%25&'()*+,-./"
    "0123456789:;%3C=%3E?@"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ%5B%5C%5D%5E_%60"
    "abcdefghijklmnopqrstuvwxyz%7B%7C%7D~%7F";
  
  // parameter encoding encodes these too: "!*'();:@&=+$,/?%#[]"
  // and encodes a space as a plus
  NSString *paramEncoded = @"+%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F"
    "0123456789%3A%3B%3C%3D%3E%3F%40"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ%5B%5C%5D%5E_%60"
    "abcdefghijklmnopqrstuvwxyz%7B%7C%7D~%7F";

  NSString *resultFull, *resultParam;
  
  resultFull = [GDataUtilities stringByURLEncodingString:fullAsciiParam];
  STAssertEqualObjects(resultFull, fullEncoded, @"URL full encoding error");
  
  resultParam = [GDataUtilities stringByURLEncodingStringParameter:fullAsciiParam];
  STAssertEqualObjects(resultParam, paramEncoded, @"URL param encoding error");
}

@end
