#import <hamcrest/HCBaseMatcher.h>


/**
    Calculates the logical negation of a matcher.
*/
@interface HCIsNot : HCBaseMatcher
{
    id<HCMatcher> matcher;
}

+ (HCIsNot*) isNot:(id<HCMatcher>)aMatcher;
- (id) initNot:(id<HCMatcher>)aMatcher;

@end


#ifdef __cplusplus
extern "C" {
#endif

/**
    Calculates the logical negation of a matcher.
    
    If the item is a matcher, calculate its logical negation.
    Otherwise, this is a shortcut to the frequently used isNot(equalTo(item)).
*/
id<HCMatcher> HC_isNot(id item);

#ifdef __cplusplus
}
#endif


#ifdef HC_SHORTHAND

/**
    Shorthand for HC_isNot, available if HC_SHORTHAND is defined.
*/
#define isNot HC_isNot

#endif
