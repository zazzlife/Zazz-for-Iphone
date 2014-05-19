//
//  FeedTableViewCell.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "ZazzApi.h"
#import "Photo.h"
#import "Profile.h"
#import "Event.h"
#import "Post.h"

@implementation FeedTableViewCell

@synthesize tableView;
@synthesize userImage;
@synthesize content;
@synthesize timestamp;
@synthesize username;

-(void)setFeed:(Feed *)feed{
    [self.userImage setImage:feed.user.photo];
    [self.username setText:feed.user.username];
    [self.timestamp setText:feed.timestamp];
    [self setNeeded_height:200];
    for(UIView* view in self.content.subviews){
        [view removeFromSuperview];
    }
    if([[feed feedType] isEqualToString:@"Photo"]){
        NSLog(@"type:photos");
        CGPoint floating_center = CGPointMake(self.tableView.center.x, self.content.frame.origin.y);
        for(Photo* photo in (NSMutableArray*)[feed content]){
            NSLog(@"photoId:%@",photo.photoId);
            UIImage* image = [ZazzApi getImage:photo.photo scaledToWidth:self.tableView.frame.size.width];
            UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
            floating_center = CGPointMake(floating_center.x, image.size.height/2);
            [imageView setCenter:floating_center];
            floating_center = CGPointMake(floating_center.x, image.size.height/2);
            [self.content addSubview:imageView];
            [self.content setFrame:CGRectMake(self.tableView.frame.origin.x, floating_center.y, self.tableView.frame.size.width, floating_center.y)];
            [self setNeeded_height:floating_center.y];
            break;
        }
    }
    else if([[feed feedType] isEqualToString:@"Post"]){
        Post* post = (Post*)[feed content];
        NSLog(@"postId:%@ text:%@",post.postId, post.message);
        UITextView* contentText = [[UITextView alloc] init];
        [contentText setCenter:self.content.center];
        [contentText setFrame:self.content.frame];
        [contentText setText:post.message];
        [self.content addSubview:contentText];
    }else if([[feed feedType] isEqualToString:@"Event"]){
        Event* event = (Event*)[feed content];
        NSLog(@"eventId:%@ text:%@",event.eventId, event.description);
        UITextView* contentText = [[UITextView alloc] init];
        [contentText setCenter:self.content.center];
        [contentText setFrame:self.content.frame];
        [contentText setText:event.description];
        [self.content addSubview:contentText];
    }
    //make the user photo a circle
    [self.userImage.layer setCornerRadius:25];
    [self.userImage.layer setMasksToBounds:YES];
}

@end
