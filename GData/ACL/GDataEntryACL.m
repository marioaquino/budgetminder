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
//  GDataEntryACL.m
//

#define GDATAENTRYACL_DEFINE_GLOBALS 1
#import "GDataEntryACL.h"

#import "GDataACLRole.h"
#import "GDataACLScope.h"


@implementation GDataEntryACL

+ (NSDictionary *)ACLNamespaces {
  NSMutableDictionary *namespaces;
  namespaces = [NSMutableDictionary dictionaryWithObject:kGDataNamespaceACL
                                                  forKey:kGDataNamespaceACLPrefix];
  
  [namespaces addEntriesFromDictionary:[GDataEntryBase baseGDataNamespaces]];
  
  return namespaces;
}

+ (GDataEntryACL *)ACLEntryWithScope:(GDataACLScope *)scope
                                role:(GDataACLRole *)role {
  
  GDataEntryACL *obj = [[[GDataEntryACL alloc] init] autorelease];
  [obj setNamespaces:[self ACLNamespaces]];
  [obj setScope:scope];
  [obj setRole:role];
  return obj;
}

+ (void)load {
  [GDataObject registerEntryClass:[self class]
            forCategoryWithScheme:kGDataCategoryScheme
                             term:kGDataCategoryACL];
}

- (void)addExtensionDeclarations {
  
  [super addExtensionDeclarations];
  
  Class entryClass = [self class];
  
  // ACLEntry extensions
  
  [self addExtensionDeclarationForParentClass:entryClass
                                   childClass:[GDataACLRole class]];  
  [self addExtensionDeclarationForParentClass:entryClass
                                   childClass:[GDataACLScope class]];  
}

- (id)init {
  self = [super init];
  if (self) {
    GDataCategory *category = [GDataCategory categoryWithScheme:kGDataCategoryScheme
                                                           term:kGDataCategoryACL];
    [self addCategory:category];
  }
  return self;
}

- (NSMutableArray *)itemsForDescription {
  
  NSMutableArray *items = [super itemsForDescription];
  
  [self addToArray:items objectDescriptionIfNonNil:[self role] withName:@"role"];
  [self addToArray:items objectDescriptionIfNonNil:[self scope] withName:@"scope"];
  
  return items;
}

#pragma mark -

- (void)setRole:(GDataACLRole *)obj {
  [self setObject:obj forExtensionClass:[GDataACLRole class]];  
}

- (GDataACLRole *)role {
  return (GDataACLRole *)[self objectForExtensionClass:[GDataACLRole class]]; 
}

- (void)setScope:(GDataACLScope *)obj {
  [self setObject:obj forExtensionClass:[GDataACLScope class]];   
}

- (GDataACLScope *)scope {
  return (GDataACLScope *)[self objectForExtensionClass:[GDataACLScope class]]; 
}

#pragma mark -

- (GDataLink *)controlledObjectLink {
  return [self linkWithRelAttributeValue:kGDataLinkRelControlledObject]; 
}

@end

@implementation GDataEntryBase (GDataACLLinks)
- (GDataLink *)ACLLink {
  return [self linkWithRelAttributeValue:kGDataLinkRelACL]; 
}

@end
