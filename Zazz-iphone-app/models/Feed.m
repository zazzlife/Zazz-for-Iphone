//
//  Feed.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Feed.h"

@implementation Feed

const NSString* FEED_POST = @"POST";
const NSString* FEED_PHOTO = @"Photo";
const NSString* FEED_EVENT = @"Event";

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

@end
