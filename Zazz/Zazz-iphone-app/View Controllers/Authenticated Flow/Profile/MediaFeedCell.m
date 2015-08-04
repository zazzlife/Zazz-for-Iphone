#import "MediaFeedCell.h"


@interface MediaFeedCell () {
}

/** Initialize class's private variables. */
- (void)_init;
/** Visualize all view's components. */
- (void)_visualize;

@end


@implementation MediaFeedCell


#pragma mark - Class's constructors
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (void)layoutSubviews {
    [super layoutSubviews];
    [self _visualize];
}


#pragma mark - Class's private methods
- (void)_init {
}
- (void)_visualize {
}


@end
