//
//  FeedTableViewCell.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ZazzApi.h"
#import "Photo.h"
#import "Profile.h"
#import "Event.h"
#import "Post.h"
#import "UIImage.h"

@implementation FeedTableViewCell

@synthesize tableView;
@synthesize feedCellBackgroundView;
@synthesize feedCellContentView;
@synthesize userImage;
@synthesize timestamp;
@synthesize username;
@synthesize _feed;
@synthesize _height;
@synthesize _neededPhotoIds;

NSMutableArray* _imageViews;
int _albumObserversCounter;

-(void)resizeHeightForLabel: (UILabel*)label {
    label.numberOfLines = 0;
    UIView *superview = label.superview;
    [label removeFromSuperview];
    [label removeConstraints:label.constraints];
    CGRect labelFrame = label.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect expectedFrame = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, 9999)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 label.font, NSFontAttributeName,
                                                                 nil]
                                                        context:nil];
        labelFrame.size = expectedFrame.size;
        labelFrame.size.height = ceil(labelFrame.size.height); //iOS7 is not rounding up to the nearest whole number
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        labelFrame.size = [label.text sizeWithFont:label.font
                                 constrainedToSize:CGSizeMake(label.frame.size.width, 9999)
                                     lineBreakMode:label.lineBreakMode];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    label.frame = labelFrame;
    [superview addSubview:label];
}



-(void)showImage:(UIButton*)imageButton{
    DetailViewController* detailView = [[DetailViewController alloc] initWithPhoto:imageButton.currentBackgroundImage andDelegate:self];
    NSArray* keys  =    [NSArray arrayWithObjects:
                         @"childController",
                         @"identifier",
                         nil];
    NSArray* objects  = [NSArray arrayWithObjects:
                         detailView,
                         [NSString stringWithFormat:@"detailView-tag%ld",imageButton.tag],
                         nil];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNextView" object:nil userInfo:userInfo];
}

-(void)setFeed:(Feed *)feed{
    _height = CELL_PADDING_TOP + CELL_HEADER_HEIGHT;
    [self set_feed:feed];
    [self.username setText:feed.user.username];
    [self.timestamp setText:[ZazzApi formatDateString:feed.timestamp]];
    [self.userImage setImage:feed.user.photo];
    if(feed.user.photo == nil){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotUserImageNotification:) name:@"gotProfile" object:nil];
    }
    [self.feedCellContentView setFrame:CGRectMake(0, CELL_HEADER_HEIGHT, self.tableView.frame.size.width-(2*CELL_PADDING_SIDES), 40)];
    for(UIView* view in self.feedCellContentView.subviews){
        [view removeFromSuperview];
    }
    if([[feed feedType] isEqualToString:@"Photo"]){
        _albumObserversCounter = 0;
        for(Photo* photo in (NSMutableArray*)[feed content]){
            UIButton* imageView;
            if(photo.image == nil){
                if(!self._neededPhotoIds)[self set_neededPhotoIds:[[NSMutableArray alloc ]init]];
                [self._neededPhotoIds addObject:photo.photoId];
                imageView = [[UIButton alloc ]init];
                [imageView setTag:[photo.photoId intValue]];
                [self.feedCellContentView addSubview:imageView];
                continue;
            }
            UIImage* image = [UIImage getImage:photo.image scaledToWidth:self.tableView.frame.size.width];
            imageView = [[UIButton alloc] init];
            [imageView setBackgroundImage:image forState:UIControlStateNormal];
            [imageView setShowsTouchWhenHighlighted:false];
            [imageView setUserInteractionEnabled:true];
            [imageView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            UIView* previousImage = (UIView*)self.feedCellContentView.subviews.lastObject;
            if (previousImage != nil) {
                [imageView setFrame:CGRectMake(0, previousImage.frame.origin.y + previousImage.frame.size.height, self.feedCellContentView.frame.size.width, image.size.height)];
            }else{
                [imageView setFrame:CGRectMake(0, 0 , self.feedCellContentView.frame.size.width, image.size.height)];
            }
            _height += image.size.height;
            [imageView setTag:[photo.photoId intValue]];
            [self.feedCellContentView addSubview:imageView];
        }
    }else{
        NSString* text = @"";
        if([[feed feedType] isEqualToString:@"Post"]){
            text = [(Post*)[feed content] message];
        }else if([[feed feedType] isEqualToString:@"Event"]){
            text = [(Event*)[feed content] description];
        }
        CGRect label_frame = CGRectMake(CELL_TEXT_CONTENT_PADDING, 0, self.feedCellContentView.frame.size.width-(2*CELL_TEXT_CONTENT_PADDING), 0);
        UILabel* label = [[UILabel alloc] initWithFrame:label_frame];
        [label setText:text];
        [self.feedCellContentView addSubview:label];
        [self resizeHeightForLabel:label];
        _height +=label.frame.size.height;
    }
    [self.feedCellBackgroundView.layer setCornerRadius:5];
    [self.feedCellBackgroundView.layer setMasksToBounds:YES];
    [self.userImage.layer setCornerRadius:25];
    [self.userImage.layer setMasksToBounds:YES];
    
    [self.feedCellBackgroundView setFrame:CGRectMake(CELL_PADDING_SIDES, CELL_PADDING_TOP, self.tableView.frame.size.width - (2*CELL_PADDING_SIDES), _height - CELL_PADDING_TOP)];
    [self.feedCellContentView setFrame:CGRectMake(0, CELL_HEADER_HEIGHT, self.feedCellBackgroundView.frame.size.width, _height - CELL_HEADER_HEIGHT - CELL_PADDING_TOP)];
}

-(void)gotUserImageNotification:(NSNotification *)notif{
    if(! [notif.name isEqualToString:@"gotProfile"]) return;
    Profile* profile = notif.object;
    if(profile.userId != self._feed.user.userId) return;
    [self.userImage setImage:profile.photo];
}

@end
