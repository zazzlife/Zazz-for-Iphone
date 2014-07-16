//
//  Feed.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Feed.h"
#import "Profile.h"
#import "Post.h"
#import "Comment.h"
#import "Photo.h"
#import "Event.h"

@implementation Feed

const NSString* FEED_POST = @"POST";
const NSString* FEED_PHOTO = @"Photo";
const NSString* FEED_EVENT = @"Event";

const int FEED_POST_INT = 0;
const int FEED_PHOTO_INT = 1;
const int FEED_EVENT_INT = 2;

@synthesize feedId;
@synthesize user;
@synthesize canCurrentUserRemoveFeed;
@synthesize feedType;
@synthesize content;
@synthesize comments;
@synthesize timestamp;

-(BOOL)isEqual:(Feed*)feed{
    return self.feedId == feed.feedId;
}

-(BOOL)getFeedInt{
    if ([self.feedType isEqualToString:FEED_EVENT]){
        return FEED_EVENT_INT;
    }else if ([self.feedType isEqualToString:FEED_PHOTO]){
        return FEED_PHOTO_INT;
    }
    return FEED_POST_INT;
}

+(Feed*)makeFeedFromDict:(NSDictionary*)feed_dict{
    
    Profile *user = [[Profile alloc] init];
    [user setPhotoUrl:[[feed_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]];
    [user setUserId:[feed_dict objectForKey:@"userId"]];
    [user setUsername:[feed_dict objectForKey:@"userDisplayName"]];
    
    Feed* feed = [[Feed alloc] init];
    [feed setUser:user];
    [feed setCanCurrentUserRemoveFeed:[[feed_dict objectForKey:@"canCurrentUserRemoveFeed"] boolValue]];
    [feed setFeedId:[feed_dict objectForKey:@"feedId"]];
    [feed setTimestamp:[feed_dict objectForKey:@"time"]];
    [feed setFeedType:[feed_dict objectForKey:@"feedType"]];
    
    //SET COMMENTS
    NSMutableArray* comments = [[NSMutableArray alloc] init];
    for(NSMutableDictionary* comment_dict in [feed_dict objectForKey:@"comments"]){
        Comment* comment = [Comment makeCommentFromDict:comment_dict];
        [comments addObject:comment];
    }
    [feed setComments:comments];
    
    //SET VARIABLE CONTENT
    if([feed.feedType isEqualToString:@"Photo"]){
        NSMutableArray* photos = [[NSMutableArray alloc] init];
        for(NSDictionary* photo_dict in [feed_dict objectForKey:@"photos"]) {
            Photo* photo = [Photo makePhotoFromDict:photo_dict];
            [photos addObject:photo];
        }
        [feed setContent:photos];
    }
    else if([feed.feedType isEqualToString:@"Post"]){
        Post* post = [Post makePostFromDict:[feed_dict objectForKey:@"post"]];
        [feed setContent:post];
    }else if([feed.feedType isEqualToString:@"Event"]){
        Event* event = [Event makeEventFromDict:[feed_dict objectForKey:@"apiEvent"]];//THIS WILL NEED TO BE FIXED FOR API V2
        [feed setContent:event];
    }
    return feed;
}

@end
