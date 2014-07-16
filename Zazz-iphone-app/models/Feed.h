//
//  Feed.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface Feed : NSObject

extern const NSString* FEED_POST;
extern const NSString* FEED_PHOTO;
extern const NSString* FEED_EVENT;

extern const int FEED_POST_INT;
extern const int FEED_PHOTO_INT;
extern const int FEED_EVENT_INT;

@property NSString* feedId;
@property Profile* user;
@property BOOL canCurrentUserRemoveFeed;
@property id content;
@property NSString* feedType; //Photo, Event, Post
@property NSMutableArray* comments;
@property NSString* timestamp;

-(BOOL)getFeedInt;
+(Feed*)makeFeedFromDict:(NSDictionary*)feed_dict;

@end
