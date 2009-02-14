#import <hamcrest/HCSelfDescribing.h>


/**
    A matcher over acceptable values.
    
    A matcher is able to describe itself to give feedback when it fails.
    
    HCMatcher implementations should @b not directly implement this protocol.
    Instead, @b extend the HCBaseMatcher class, which will ensure that the HCMatcher API can grow
    to support new features and remain compatible with all HCMatcher implementations.
*/
@protocol HCMatcher <HCSelfDescribing>

/**
    Evaluates the matcher for argument @a item.

    @param item The object against which the matcher is evaluated.
    @return @c YES if @a item matches, otherwise @c NO.
*/
- (BOOL) matches:(id)item;

@end
