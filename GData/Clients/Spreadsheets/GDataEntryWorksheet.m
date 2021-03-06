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
//  GDataEntryWorksheet.m
//

#define GDATAENTRYWORKSHEET_DEFINE_GLOBALS 1

#import "GDataEntryWorksheet.h"
#import "GDataEntrySpreadsheet.h"
#import "GDataRowColumnCount.h"

// extensions



@implementation GDataEntryWorksheet


+ (GDataEntryWorksheet *)worksheetEntry {
  GDataEntryWorksheet *entry = [[[GDataEntryWorksheet alloc] init] autorelease];

  [entry setNamespaces:[GDataEntrySpreadsheet spreadsheetNamespaces]];
  return entry;
}

#pragma mark -

+ (void)load {
  [GDataObject registerEntryClass:[self class]
            forCategoryWithScheme:kGDataCategorySchemeSpreadsheet 
                             term:kGDataCategoryWorksheet];
}

- (void)addExtensionDeclarations {
  
  [super addExtensionDeclarations];
  
  Class entryClass = [self class];
  
  
  // Worksheet extensions
  [self addExtensionDeclarationForParentClass:entryClass
                                   childClass:[GDataColumnCount class]];
  [self addExtensionDeclarationForParentClass:entryClass
                                   childClass:[GDataRowCount class]];  
}

- (NSMutableArray *)itemsForDescription {
  
  NSMutableArray *items = [super itemsForDescription];
  
  NSString *colStr = [NSString stringWithFormat:@"%d", [self columnCount]];
  NSString *rowStr = [NSString stringWithFormat:@"%d", [self rowCount]];
  
  [self addToArray:items objectDescriptionIfNonNil:colStr withName:@"cols"];
  [self addToArray:items objectDescriptionIfNonNil:rowStr withName:@"rows"];
  
  return items;
}

- (id)init {
  self = [super init];
  if (self) {
    [self addCategory:[GDataCategory categoryWithScheme:kGDataCategorySchemeSpreadsheet
                                                   term:kGDataCategoryWorksheet]];

    // set a default row & column count, as in the Java
    [self setRowCount:100];
    [self setColumnCount:20];
  }
  return self;
}

#pragma mark -

- (int)rowCount {
  GDataRowCount *rowCount = [self objectForExtensionClass:[GDataRowCount class]];
  
  return [rowCount count];
}

- (void)setRowCount:(int)val {
  GDataRowCount *obj = [GDataRowCount rowCountWithInt:val];
  [self setObject:obj forExtensionClass:[GDataRowCount class]];
}

- (int)columnCount {
  GDataColumnCount *columnCount = [self objectForExtensionClass:[GDataColumnCount class]];
  
  return [columnCount count];
}

- (void)setColumnCount:(int)val {
  GDataColumnCount *obj = [GDataColumnCount columnCountWithInt:val];
  [self setObject:obj forExtensionClass:[GDataColumnCount class]];
}

#pragma mark -

- (GDataLink *)spreadsheetLink {
  return [self alternateLink]; 
}

- (GDataLink *)listLink {
  return [self linkWithRelAttributeValue:kGDataLinkListFeed]; 
}

- (GDataLink *)cellsLink {
  return [self linkWithRelAttributeValue:kGDataLinkCellsFeed]; 
}
@end
