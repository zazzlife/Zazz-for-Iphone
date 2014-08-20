//
//  ZazzFeed.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"
#import "Feed.h"

@interface ZazzFeed : NSObject<NSURLConnectionDataDelegate>

@property NSMutableData* _receivedData;

- (void) getMyFeed;
- (void) getMyFeedAfter:(NSString*)feed_id;
- (void) getFeedCategory:(NSString*)category_id;
- (void) getFeedCategory:(NSString*)category_id after:(NSString*)feed_id;
- (void) getUserFeed:(NSString*)user_id;
- (void) getUserFeed:(NSString*)user_id after:(NSString *)feedId;

@end
