#import "UserTypeCell.h"


@interface UserTypeCell () {
}


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

@end


@implementation UserTypeCell


@synthesize titleLabel=_titleLabel;


#pragma mark - Cleanup memory
- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (void)awakeFromNib {
    [self _init];
    [self _visualize];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self _localize];
    
    if (self.selected) {
        _imageView.backgroundColor = kColor_BG_Yellow;
    }
    else {
        _imageView.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark - Class's private methods
- (void)_init {
}
- (void)_localize {
}
- (void)_visualize {
    CGFloat radius = CGRectGetMidX(_imageView.bounds);
    [_imageView roundCorner:radius];
    _imageView.layer.borderWidth = 1.0f;
    _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _lineImageView.image = kImage_BG_TextField;
}


@end
