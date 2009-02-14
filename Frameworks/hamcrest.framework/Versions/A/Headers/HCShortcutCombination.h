#import <stdarg.h>
#import <hamcrest/HCBaseMatcher.h>


@interface HCShortcutCombination : HCBaseMatcher
{
    NSArray* matchers;
}

- (id) initWithMatchers:(NSArray*)theMatchers;
- (BOOL) pMatches:(id)item shortcut:(BOOL)shortcut;
- (void) pDescribeTo:(id<HCDescription>)description operatorName:(NSString*)operatorName;

@end


#ifdef __cplusplus
extern "C" {
#endif

NSMutableArray* HC_collectMatchers(id<HCMatcher> matcher, va_list args);

#ifdef __cplusplus
}
#endif
