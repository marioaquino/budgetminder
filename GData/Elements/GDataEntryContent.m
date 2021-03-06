/* Copyright (c) 2007-2008 Google Inc.
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
//  GDataEntryContent.m
//

#import "GDataEntryContent.h"

static NSString* const kLangAttr = @"xml:lang";
static NSString* const kTypeAttr = @"type";
static NSString* const kSourceAttr = @"src";

static BOOL IsTypeEqualToText(NSString *str) {
  // internal utility routine
  return (str == nil)
  || [str isEqual:@"text"]
  || [str hasPrefix:@"text/"]
  || [str isEqual:@"html"]
  || [str isEqual:@"xhtml"];
}


@implementation GDataEntryContent

+ (NSString *)extensionElementURI       { return kGDataNamespaceAtom; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceAtomPrefix; }
+ (NSString *)extensionElementLocalName { return @"content"; }

+ (id)contentWithString:(NSString *)str {
  
  // RFC4287 Sec 4.1.3.1. says that omitted type attributes are assumed to be
  // "text", so we don't need to explicitly set it to text
  
  GDataEntryContent *obj = [[[self alloc] init] autorelease];
  [obj setStringValue:str];
  return obj;
}

+ (id)contentWithSourceURI:(NSString *)str type:(NSString *)type {
  
  GDataEntryContent *obj = [[[self alloc] init] autorelease];
  [obj setSourceURI:str];
  [obj setType:type];
  return obj;
}

+ (id)textConstructWithString:(NSString *)str {
  
  // deprecated; kept for compatibility with the previous
  // implementation of GDataEntryContent
#if DEBUG
  NSLog(@"GDataEntryContent: +textConstructWithString deprecated, use +contentWithString");
#endif
  
  return [self contentWithString:str];
}

- (void)addParseDeclarations {
  
  NSArray *attrs = [NSArray arrayWithObjects:
                    kTypeAttr, kLangAttr, kSourceAttr, nil];
  
  [self addLocalAttributeDeclarations:attrs];
  
  // we're not calling -addContentValueDeclaration since the content may not
  // be plain text but rather XML for an entry or feed that we will parse
}

- (NSArray *)attributesIgnoredForEquality {
  
  // ignore the "type" attribute since we test for it uniquely below
  return [NSArray arrayWithObject:kTypeAttr];
}

- (id)initWithXMLElement:(NSXMLElement *)element
                  parent:(GDataObject *)parent {
  self = [super initWithXMLElement:element
                            parent:parent];
  if (self) {
    
    NSString *type = [self type];
    if (IsTypeEqualToText(type)) {
      
      // contents is plain text
      NSString *str = [self stringValueFromElement:element];
      [self setStringValue:str];
      
    } else if ([type hasPrefix:@"application/atom+xml;"]) {
      
      // content is a feed or entry stored in unknownChildren
      GDataObject *obj = [self objectForChildOfElement:element
                                         qualifiedName:@"*"
                                          namespaceURI:@"*"
                                           objectClass:nil];
      [self setChildObject:obj];
    }
  }
  return self;
}

- (void)dealloc {
  [textValue_ release];
  [childObject_ release];
  [super dealloc];
}

- (NSXMLElement *)XMLElement {
  
  NSXMLElement *element = [self XMLElementWithExtensionsAndDefaultName:nil];
  
  NSString *str = [self stringValue];
  if ([str length] > 0) {
    [element addStringValue:str]; 
  }
  
  GDataObject *obj = [self childObject];
  if (obj) {
    NSXMLElement *elem = [obj XMLElement];
    [element addChild:elem];
  }
  
  return element;
}

- (id)copyWithZone:(NSZone *)zone {
  GDataEntryContent* newObj = [super copyWithZone:zone];
  
  [newObj setStringValue:[self stringValue]];
  [newObj setChildObject:[[[self childObject] copy] autorelease]];
  
  return newObj;
}

- (BOOL)isEqual:(GDataEntryContent *)other {
  
  // override isEqual: to allow nil types to be considered equal to "text"
  return [super isEqual:other]
  
    // a missing type attribute is equal to "text" per RFC 4287 3.1.1
    //
    // consider them equal if both are some flavor of "text"
    && (AreEqualOrBothNil([self type], [other type])
        || (IsTypeEqualToText([self type]) && IsTypeEqualToText([other type])))
    && AreEqualOrBothNil([self stringValue], [other stringValue])
    && AreEqualOrBothNil([self childObject], [other childObject]);
}

- (NSMutableArray *)itemsForDescription {
  
  NSMutableArray *items = [super itemsForDescription];
  [self addToArray:items objectDescriptionIfNonNil:[self stringValue] withName:@"content"];
  
  GDataObject *obj = [self childObject];
  if (obj != nil) {
    NSString *className = NSStringFromClass([obj class]);
    [self addToArray:items objectDescriptionIfNonNil:className withName:@"childObject"];
  }
  return items;
}

#pragma mark -

- (NSString *)lang {
  return [self stringValueForAttribute:kLangAttr];
}

- (void)setLang:(NSString *)str {
  [self setStringValue:str forAttribute:kLangAttr];
}

- (NSString *)type {
  return [self stringValueForAttribute:kTypeAttr];
}

- (NSString *)sourceURI {
  return [self stringValueForAttribute:kSourceAttr];
}

- (void)setSourceURI:(NSString *)str {
  [self setStringValue:str forAttribute:kSourceAttr];
}

- (void)setType:(NSString *)str {
  [self setStringValue:str forAttribute:kTypeAttr];
}

- (NSString *)stringValue {
  return textValue_;
}

- (void)setStringValue:(NSString *)str {
  [textValue_ autorelease];
  textValue_ = [str copy];
}

- (GDataObject *)childObject {
  return childObject_;
}

- (void)setChildObject:(GDataObject *)obj {
  [childObject_ autorelease];
  childObject_ = [obj retain];
}

@end

