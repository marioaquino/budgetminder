#import <hamcrest/HCBaseMatcher.h>


/**
    Decorates another HCMatcher, retaining the behavior but allowing tests to be slightly more
    expressive.

    For example,
@code
assertThat(cheese, equalTo(smelly))
@endcode
    vs.
@code
assertThat(cheese, is(equalTo(smelly)))
@endcode
*/
@interface HCIs : HCBaseMatcher
{
    id<HCMatcher> matcher;
}

+ (HCIs*) is:(id<HCMatcher>)aMatcher;
- (id) initWithMatcher:(id<HCMatcher>)aMatcher;

@end


#ifdef __cplusplus
extern "C" {
#endif

/**
    Decorates another HCMatcher, retaining the behavior but allowing tests to be slightly more
    expressive.
    
    If the item is a matcher, use it to determine matches.
    Otherwise, this is a shortcut to the frequently used is(equalTo(item)).
*/
id<HCMatcher> HC_is(id item);

#ifdef __cplusplus
}
#endif


#ifdef HC_SHORTHAND

/**
    Shorthand for HC_is, available if HC_SHORTHAND is defined.
*/
#define is HC_is

#endif
