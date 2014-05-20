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

@property NSString* feedId;
@property Profile* user;
@property BOOL canCurrentUserRemoveFeed;
@property id content;
@property NSString* feedType;
@property NSMutableArray* comments;
@property NSString* timestamp;

@end
