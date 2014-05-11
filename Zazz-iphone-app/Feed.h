//
//  Feed.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

typedef enum {
    Photo, Post, Event
} FeedType;

@protocol FeedType <NSObject>

-(void)getContent;

@end

@interface Feed : NSObject

@property Profile* user;
@property BOOL canCurrentUserRemoveFeed;
@property FeedType feedType;
@property id contentProvider;
@property NSMutableArray* comments;

@end
