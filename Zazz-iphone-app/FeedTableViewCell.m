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
#import "UILabel.h"
#import "Post.h"
#import "UIImage.h"
#import "DetailViewItem.h"
#import "Comment.h"
<<<<<<< HEAD
=======
#import "UIImageView+WebCache.h"
#import "Feed.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
>>>>>>> origin/feature/profile-view

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
@synthesize profileButton;

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
        NSLog(@"Fatal Error on FeedTableViewCell:resizeHeightForLabel:%@",label);
//#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
//        labelFrame.size = [label.text sizeWithFont:label.font
//                                 constrainedToSize:CGSizeMake(label.frame.size.width, 9999)
//                                     lineBreakMode:label.lineBreakMode];
//#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    label.frame = labelFrame;
    [superview addSubview:label];
}



-(void)showImage:(UIButton*)imageButton{
    int idx  = [imageButton.restorationIdentifier intValue];
    Photo* photo = [((NSMutableArray*)[self._feed content]) objectAtIndex:idx];
    
    DetailViewItem* detailItem = [[DetailViewItem alloc]init];
    [detailItem setImage:photo.image];
    [detailItem setType:COMMENT_TYPE_PHOTO];
    [detailItem setItemId:photo.photoId];
    [detailItem setComments:_feed.comments];
    [detailItem setDescription:photo.description];
    [detailItem setUser:_feed.user];
    [detailItem setLikes:0];
    [detailItem setCategories:photo.categories];
    DetailViewController* detailView = [[DetailViewController alloc] initWithDetailItem:detailItem];
    
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
    [self.userImage setImageWithURL:[NSURL URLWithString:feed.user.photoUrl]];
    [self.feedCellContentView setFrame:CGRectMake(0, CELL_HEADER_HEIGHT, self.tableView.frame.size.width-(2*CELL_PADDING_SIDES), 40)];
    for(UIView* view in self.feedCellContentView.subviews){
        [view removeFromSuperview];
    }
    if([[feed feedType] isEqualToString:@"Photo"]){
        _albumObserversCounter = 0;
        CGRect contentFrame = self.contentView.frame;
        for(int _photoIdx = 0; _photoIdx<((NSMutableArray*)[feed content]).count; _photoIdx++){
            Photo* photo = [((NSMutableArray*)[feed content]) objectAtIndex:_photoIdx];
            UIButton* imageButton;
            if(photo.image == nil){
                if(!self._neededPhotoIds)[self set_neededPhotoIds:[[NSMutableArray alloc ]init]];
                [self._neededPhotoIds addObject:photo.photoId];
                imageButton = [[UIButton alloc ]init];
                [self.feedCellContentView addSubview:imageButton];
                continue;
            }
            UIImage* image = [UIImage getImage:photo.image scaledToWidth:self.tableView.frame.size.width];
            imageButton = [[UIButton alloc] init];
            [imageButton setBackgroundImage:image forState:UIControlStateNormal];
            [imageButton setShowsTouchWhenHighlighted:false];
            [imageButton setUserInteractionEnabled:true];
            [imageButton setRestorationIdentifier:[NSString stringWithFormat:@"%d",_photoIdx]];
//            NSLog(@"index: %d feed_id:%@",_photoIdx, self._feed.feedId);
            [imageButton addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            UIView* previousImage = (UIView*)self.feedCellContentView.subviews.lastObject;
            if (previousImage != nil) {
                [imageButton setFrame:CGRectMake(0, previousImage.frame.origin.y + previousImage.frame.size.height, self.feedCellContentView.frame.size.width, image.size.height)];
            }else{
                [imageButton setFrame:CGRectMake(0, 0 , self.feedCellContentView.frame.size.width, image.size.height)];
            }
            UILabel* description = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(contentFrame)+ 10 ,CGRectGetMaxY(imageButton.frame)+5,CGRectGetWidth(contentFrame) - 50, 100)];
            [description setText:photo.description];
            [description resizeWithFlexibleHeight];
            [self.feedCellContentView addSubview:description];
            _height += image.size.height + (description.frame.size.height + 10);
            [imageButton setTag:[photo.photoId intValue]];
            [self.feedCellContentView addSubview:imageButton];
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
    [self.profileButton setTag:[feed.user.userId integerValue]];
    
}

<<<<<<< HEAD
=======
-(void)didSelectContent:(id)content{
    Feed* feedItem = self._feed;
    DetailViewItem* detailItem = [[DetailViewItem alloc] init];
    if([feedItem.feedType isEqualToString:FEED_PHOTO]){
        Photo* photo = (Photo*)[(NSMutableArray*)[feedItem content] objectAtIndex:0];
        [detailItem setImage:photo.image];
        [detailItem setDescription:photo.description];
        [detailItem setCategories:photo.categories];
        [detailItem setType:COMMENT_TYPE_PHOTO];
        [detailItem setItemId:photo.photoId];
        [detailItem setUser:photo.user];
        [detailItem setLikes:0];
    }else if([feedItem.feedType isEqualToString:FEED_POST]){
        Post* post = (Post*)[feedItem content];
        [detailItem setImage:nil];
        [detailItem setDescription:post.message];
        [detailItem setCategories:post.categories];
        [detailItem setType:COMMENT_TYPE_POST];
        [detailItem setItemId:post.postId];
        [detailItem setUser:post.fromUser];
        [detailItem setLikes:0];
    }else if([feedItem.feedType isEqualToString:FEED_EVENT]){
        Event* event = (Event*)[feedItem content];
        [detailItem setImage:nil];
        [detailItem setDescription:event.description];
        [detailItem setType:COMMENT_TYPE_EVENT];
        [detailItem setItemId:event.eventId];
        [detailItem setUser:event.user];
        [detailItem setLikes:0];
    }
    DetailViewController* detailViewController  = [[DetailViewController alloc] initWithDetailItem:detailItem];
    NSArray* keys  =    [NSArray arrayWithObjects: @"childController",  @"identifier", nil];
    NSArray* objects  = [NSArray arrayWithObjects: detailViewController, [NSString stringWithFormat:@"detailView-feed%@",feedItem.feedId], nil];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNextView" object:detailViewController userInfo:userInfo];
}

>>>>>>> origin/feature/profile-view
//
//-(void)gotUserImageNotification:(NSNotification *)notif{
//    if(! [notif.name isEqualToString:@"gotProfile"]) return;
//    Profile* profile = notif.object;
//    if(profile.profile_id != self._feed.user.userId) return;
//    [self.userImage setImage:profile.image];
//}

@end
