/* Copyright (c) 2008 Google Inc.
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
//  GDataFeedFinancePortfolio.m
//

#import "GDataFeedFinanceTransaction.h"
#import "GDataEntryFinanceTransaction.h"

#import "GDataEntryFinancePortfolio.h" // for namespaces

@implementation GDataFeedFinanceTransaction

+ (GDataFeedFinanceTransaction *)transactionFeed {
  
  GDataFeedFinanceTransaction *feed = [[[self alloc] init] autorelease];
  
  [feed setNamespaces:[GDataEntryFinancePortfolio financeNamespaces]];
  
  return feed;
}

+ (void)load {
  [GDataObject registerFeedClass:[self class]
           forCategoryWithScheme:nil 
                            term:kGDataCategoryFinanceTransaction];
}

// needs no custom -addExtensionDeclarations method

- (id)init {
  self = [super init];
  if (self) {
    [self addCategory:[GDataCategory categoryWithScheme:kGDataCategoryScheme
                                                   term:kGDataCategoryFinanceTransaction]];
  }
  return self;
}

// needs no custom -itemsForDescription method

- (Class)classForEntries {
  return [GDataEntryFinanceTransaction class]; 
}

@end
