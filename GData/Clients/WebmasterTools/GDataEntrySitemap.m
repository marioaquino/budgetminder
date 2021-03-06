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
//  GDataEntrySitemap.m
//

#import "GDataEntrySitemap.h"
#import "GDataEntrySite.h" // for namespace declarations

@implementation GDataSitemapStatus
+ (NSString *)extensionElementURI       { return kGDataNamespaceWebmasterTools; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceWebmasterToolsPrefix; }
+ (NSString *)extensionElementLocalName { return @"sitemap-status"; }
@end

@implementation GDataSitemapLastDownloaded
+ (NSString *)extensionElementURI       { return kGDataNamespaceWebmasterTools; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceWebmasterToolsPrefix; }
+ (NSString *)extensionElementLocalName { return @"sitemap-last-downloaded"; }
@end

@implementation GDataSitemapURLCount
+ (NSString *)extensionElementURI       { return kGDataNamespaceWebmasterTools; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceWebmasterToolsPrefix; }
+ (NSString *)extensionElementLocalName { return @"sitemap-url-count"; }
@end

@implementation GDataSitemapType
+ (NSString *)extensionElementURI       { return kGDataNamespaceWebmasterTools; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceWebmasterToolsPrefix; }
+ (NSString *)extensionElementLocalName { return @"sitemap-type"; }
@end

@implementation GDataSitemapMobileMarkupLanguage
+ (NSString *)extensionElementURI       { return kGDataNamespaceWebmasterTools; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceWebmasterToolsPrefix; }
+ (NSString *)extensionElementLocalName { return @"sitemap-mobile-markup-language"; }
@end

@implementation GDataSitemapNewsPublicationLabel
+ (NSString *)extensionElementPrefix { return kGDataNamespaceWebmasterToolsPrefix; }
+ (NSString *)extensionElementURI { return kGDataNamespaceWebmasterTools; }
+ (NSString *)extensionElementLocalName { return @"sitemap-news-publication-label"; }
@end

@implementation GDataEntrySitemapBase

+ (id)sitemapEntry {
  
  GDataEntrySitemapBase *obj;
  obj = [[[[self class] alloc] init] autorelease];
  
  [obj setNamespaces:[GDataEntrySite webmasterToolsNamespaces]];
  
  return obj;
}

#pragma mark -


- (void)addExtensionDeclarations {
  
  [super addExtensionDeclarations];
  
  Class entryClass = [self class];
  
  [self addExtensionDeclarationForParentClass:entryClass
                                   childClass:[GDataSitemapStatus class]];  
  [self addExtensionDeclarationForParentClass:entryClass
                                   childClass:[GDataSitemapLastDownloaded class]];  
  [self addExtensionDeclarationForParentClass:entryClass
                                   childClass:[GDataSitemapURLCount class]];  
}

- (NSMutableArray *)itemsForDescription {
  
  NSMutableArray *items = [super itemsForDescription];
  
  [self addToArray:items objectDescriptionIfNonNil:[self sitemapStatus] withName:@"status"];
  [self addToArray:items objectDescriptionIfNonNil:[self lastDownloadDate] withName:@"lastDownload"];
  [self addToArray:items objectDescriptionIfNonNil:[self sitemapURLCount] withName:@"URLCount"];

  return items;
}

#pragma mark -

- (NSString *)sitemapStatus {
  GDataSitemapStatus *obj;
  
  obj = [self objectForExtensionClass:[GDataSitemapStatus class]];
  return [obj stringValue];
}

- (void)setSitemapStatus:(NSString *)str {
  GDataSitemapStatus *obj = [GDataSitemapStatus valueWithString:str];
  [self setObject:obj forExtensionClass:[GDataSitemapStatus class]]; 
}

- (GDataDateTime *)lastDownloadDate {
  GDataSitemapLastDownloaded *obj;
  
  obj = [self objectForExtensionClass:[GDataSitemapLastDownloaded class]]; 
  return [obj dateTimeValue]; 
}

- (void)setLastDownloadDate:(GDataDateTime *)dateTime {
  GDataSitemapLastDownloaded *obj;
  
  obj = [GDataSitemapLastDownloaded valueWithDateTime:dateTime];
  [self setObject:obj forExtensionClass:[GDataSitemapLastDownloaded class]];
}

- (NSNumber *)sitemapURLCount {
  GDataSitemapURLCount *obj;
  
  obj = [self objectForExtensionClass:[GDataSitemapURLCount class]];
  return [obj intNumberValue];
}

- (void)setSitemapURLCount:(NSNumber *)num {
  GDataSitemapURLCount *obj = nil;
  
  if (num != nil) {
    obj = [GDataSitemapURLCount valueWithNumber:num];
  }
  [self setObject:obj forExtensionClass:[GDataSitemapURLCount class]];
}

@end

@implementation GDataEntrySitemapRegular

+ (void)load {
  [GDataObject registerEntryClass:[self class]
            forCategoryWithScheme:kGDataCategoryScheme 
                             term:kGDataCategorySitemapRegular];
}

- (id)init {
  self = [super init];
  if (self) {
    GDataCategory *category;
    
    category = [GDataCategory categoryWithScheme:kGDataCategoryScheme
                                            term:kGDataCategorySitemapRegular];
    [self addCategory:category];
  }
  return self;
}

- (NSMutableArray *)itemsForDescription {
  
  NSMutableArray *items = [super itemsForDescription];
  
  [self addToArray:items objectDescriptionIfNonNil:[self sitemapType] withName:@"sitemapType"];
  
  return items;
}

- (void)addExtensionDeclarations {
  
  [super addExtensionDeclarations];
  
  [self addExtensionDeclarationForParentClass:[self class]
                                   childClass:[GDataSitemapType class]];  
}

#pragma mark -

- (NSString *)sitemapType {
  GDataSitemapType *obj;
  
  obj = [self objectForExtensionClass:[GDataSitemapType class]];
  return [obj stringValue];
}

- (void)setSitemapType:(NSString *)str {
  GDataSitemapType *obj = nil;
  
  if (str != nil) {
    obj = [GDataSitemapType valueWithString:str];
  }
  [self setObject:obj forExtensionClass:[GDataSitemapType class]]; 
}

@end

@implementation GDataEntrySitemapMobile

+ (void)load {
  [GDataObject registerEntryClass:[self class]
            forCategoryWithScheme:kGDataCategoryScheme 
                             term:kGDataCategorySitemapMobile];
}

- (id)init {
  self = [super init];
  if (self) {
    GDataCategory *category;
    
    category = [GDataCategory categoryWithScheme:kGDataCategoryScheme
                                            term:kGDataCategorySitemapMobile];
    [self addCategory:category];
  }
  return self;
}

- (void)addExtensionDeclarations {
  
  [super addExtensionDeclarations];
  
  [self addExtensionDeclarationForParentClass:[self class]
                                   childClass:[GDataSitemapMobileMarkupLanguage class]];  
}

- (NSMutableArray *)itemsForDescription {
  
  NSMutableArray *items = [super itemsForDescription];
  
  [self addToArray:items objectDescriptionIfNonNil:[self markupLanguage] withName:@"markupLang"];

  return items;
}

#pragma mark -

- (NSString *)markupLanguage {
  GDataSitemapMobileMarkupLanguage *obj;
  
  obj = [self objectForExtensionClass:[GDataSitemapMobileMarkupLanguage class]];
  return [obj stringValue];
}

- (void)setMarkupLanguage:(NSString *)str {
  GDataSitemapMobileMarkupLanguage *obj = nil;
  
  if (str != nil) {
    obj = [GDataSitemapMobileMarkupLanguage valueWithString:str];
  }
  [self setObject:obj forExtensionClass:[GDataSitemapMobileMarkupLanguage class]]; 
}

@end

@implementation GDataEntrySitemapNews

+ (void)load {
  [GDataObject registerEntryClass:[self class]
            forCategoryWithScheme:kGDataCategoryScheme 
                             term:kGDataCategorySitemapNews];
}

- (id)init {
  self = [super init];
  if (self) {
    GDataCategory *category;
    
    category = [GDataCategory categoryWithScheme:kGDataCategoryScheme
                                            term:kGDataCategorySitemapNews];
    [self addCategory:category];
  }
  return self;
}

- (void)addExtensionDeclarations {
  
  [super addExtensionDeclarations];
  
  [self addExtensionDeclarationForParentClass:[self class]
                                   childClass:[GDataSitemapNewsPublicationLabel class]];  
}

- (NSMutableArray *)itemsForDescription {
  
  NSMutableArray *items = [super itemsForDescription];
  
  [self addToArray:items objectDescriptionIfNonNil:[self publicationLabel] withName:@"pubLabel"];
  
  return items;
}


#pragma mark -

- (NSString *)publicationLabel {
  GDataSitemapNewsPublicationLabel *obj;
  
  obj = [self objectForExtensionClass:[GDataSitemapNewsPublicationLabel class]];
  return [obj stringValue];
}

- (void)setPublicationLabel:(NSString *)str {
  GDataSitemapNewsPublicationLabel *obj = nil;
  
  if (str != nil) {
    obj = [GDataSitemapNewsPublicationLabel valueWithString:str];
  }
  [self setObject:obj forExtensionClass:[GDataSitemapNewsPublicationLabel class]]; 
}

@end



