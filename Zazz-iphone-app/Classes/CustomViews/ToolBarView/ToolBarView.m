//
//  ToolBarView.m
//  SecretTestApp
//
//  Created by Aaron Pang on 3/28/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import "ToolBarView.h"
#import "UIFont+SecretFont.h"
#import "CategoryStat.h"
#import "UIImage.h"
#import "UIColor.h"

@implementation ToolBarView

    UIButton *_moreButton;
    UIButton *_commentButton;
    UILabel *_commentCountLabel;
    UIButton *_likeButton;
    UILabel *_likeCountLabel;
    
    NSInteger _likeCounter;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Obviously my secret would have at least 10 likes
//        _likeCounter = 10;
        
//        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 160, 22)];
//        _cityLabel.text = @"....................";
//        _cityLabel.font = [UIFont secretFontLightWithSize:14.f];
//        _cityLabel.textColor = [UIColor whiteColor];
//        _cityLabel.textAlignment = NSTextAlignmentLeft;
//        _cityLabel.backgroundColor = [UIColor clearColor];
//        [_cityLabel sizeToFit];
//        [self addSubview:_cityLabel];
        
        // Hardcoded the frames for all of these for simplicity and quickness
//        _moreButton = [[UIButton alloc] initWithFrame:(CGRect){
//            .origin = {
//                CGRectGetMaxX(_cityLabel.frame) + 98, CGRectGetMinY(_cityLabel.frame) + 3
//            },
//            .size = {22, 13}
//        }];
//        [_moreButton setImage:[UIImage imageNamed:@"moreButton.png"] forState:UIControlStateNormal];
//        [self addSubview:_moreButton];

        CGRect _commentFrame = CGRectMake(CGRectGetWidth(frame) - 50, 3, 20, 15);
        _commentButton = [[UIButton alloc] initWithFrame:_commentFrame];
        [_commentButton setImage:[UIImage imageNamed:@"commentButton.png"] forState:UIControlStateNormal];
        [_commentButton setHidden:true];
        [self addSubview:_commentButton];
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.font = [UIFont secretFontLightWithSize:13.f];
        _commentCountLabel.textColor = [UIColor whiteColor];
        _commentCountLabel.textAlignment = NSTextAlignmentLeft;
        _commentCountLabel.frame = (CGRect) {.origin = {CGRectGetMaxX(_commentFrame) + 6, CGRectGetMinY(_commentFrame) }};
        _commentCountLabel.backgroundColor = [UIColor clearColor];
        [_commentCountLabel setHidden:true];
        [self addSubview:_commentCountLabel];
        
        
        CGRect _likeFrame = CGRectMake(CGRectGetMinX(_commentFrame)-80, CGRectGetMinY(_commentFrame), CGRectGetWidth(_commentFrame), CGRectGetHeight(_commentFrame));
        _likeButton = [[UIButton alloc] initWithFrame:_likeFrame];
        [_likeButton setImage:[UIImage imageNamed:@"likeButtonToolbar_unselected"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"likeButtonToolbar_selected"] forState:UIControlStateSelected];
        [_likeButton setHidden:true];
        [_likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.font = [UIFont secretFontLightWithSize:13.f];
        _likeCountLabel.textColor = [UIColor whiteColor];
        _likeCountLabel.textAlignment = NSTextAlignmentLeft;
        _likeCountLabel.frame = (CGRect) {.origin = {CGRectGetMaxX(_likeFrame) + 6, CGRectGetMinY(_likeFrame) }};
        _likeCountLabel.hidden = true;
        _likeCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_likeCountLabel];
    }
    return self;
}

- (void)setNumberOfComments:(NSInteger)comments {
    if(comments > 0){
        [_commentCountLabel setText:[NSString stringWithFormat:@"%ld",comments]];
        [_commentCountLabel sizeToFit];
        [_commentCountLabel setHidden:false];
        [_commentButton setHidden:false];
    }
}

-(void)setCategories:(NSMutableArray*)category_ids{
    CGFloat inset = 0;
    for(NSString* category_id in category_ids){
        CategoryStat* category = [[CategoryStat alloc] init];
        [category setCategory_id:category_id];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[category getIconName] withColor:[UIColor colorFromHexString:COLOR_ZAZZ_WHITE]]];
        imageView.frame = CGRectMake(inset+5, 0, 20, 20);
        [self addSubview:imageView];
        inset += 20;
    }
}

- (void)setLikes:(int)likes{
    if(likes>0){
        [_likeCountLabel setText:[NSString stringWithFormat:@"%d",likes]];
        [_likeCountLabel sizeToFit];
        [_likeCountLabel setHidden:false];
        [_likeButton setHidden:false];
    }
}

- (void)likeButtonTapped:(id)sender{
    _likeButton.selected = !_likeButton.selected;
    if (_likeButton.selected) {
        _likeCounter++;
        // Don't let the user interrupt the animation
        _likeButton.userInteractionEnabled = NO;
        const NSInteger pixelsToScale = 9.0f;
        const NSInteger pixelsToShrink = 4.0f;
        CGRect likeButtonRect = _likeButton.frame;
        
        // Play that like/heart beat animation!
        [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _likeButton.frame = (CGRect){.origin = {CGRectGetMinX(likeButtonRect) - pixelsToScale / 2.0f, CGRectGetMinY(likeButtonRect) - pixelsToScale / 2.0f}, .size = {CGRectGetWidth(likeButtonRect) + pixelsToScale, CGRectGetHeight(likeButtonRect) + pixelsToScale}};
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _likeButton.frame = (CGRect) {.origin = {CGRectGetMinX(likeButtonRect) + pixelsToShrink / 2.0f, CGRectGetMinY(likeButtonRect) + pixelsToShrink / 2.0f}, .size = {CGRectGetWidth(likeButtonRect) - pixelsToShrink, CGRectGetHeight(likeButtonRect) - pixelsToShrink}};
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _likeButton.frame = likeButtonRect;
                } completion:^(BOOL finished) {
                    _likeButton.userInteractionEnabled = YES;
                }];
            }];
        }];
    } else {
        _likeCounter--;
    }
    [_likeCountLabel setText:[NSString stringWithFormat:@"%ld",(long)_likeCounter]];
}

@end
