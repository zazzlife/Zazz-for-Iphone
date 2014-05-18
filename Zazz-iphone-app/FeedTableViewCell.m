//
//  FeedTableViewCell.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "Photo.h"
#import "Profile.h"
#import "Event.h"
#import "Post.h"

@implementation FeedTableViewCell

@synthesize userImage;
@synthesize content;
@synthesize timestamp;
@synthesize username;

-(void)setFeed:(Feed *)feed{
    [self.userImage setImage:feed.user.photo];
    [self.username setText:feed.user.username];
    [self.timestamp setText:feed.timestamp];
    for(UIView* view in self.content.subviews){
        [view removeFromSuperview];
    }
    if([[feed feedType] isEqualToString:@"Photo"]){
        NSLog(@"type:photos");
        NSMutableArray* photos = (NSMutableArray*)[feed content];
        for(Photo* photo in photos){
            NSLog(@"photoId:%@",photo.photoId);
            UIImageView* imageView = [[UIImageView alloc] initWithImage:photo.photo];
            [imageView setCenter:self.content.center];
            [imageView setFrame:self.content.frame];
            [self.content addSubview:imageView];
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
