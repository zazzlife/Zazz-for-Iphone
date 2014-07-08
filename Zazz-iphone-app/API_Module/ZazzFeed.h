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

@property ZazzApi* _delegate;
@property NSMutableData* _receivedData;

- (void) getMyFeedDelegate:(id)delegate;
- (void) getMyFeedAfter:(NSString*)feed_id delegate:(id)delegate;
- (void) getFeedCategory:(NSString*)category_id delegate:(id)delegate;
- (void) getFeedCategory:(NSString*)category_id after:(NSString*)feed_id delegate:(id)delegate;
- (void) getFeedForUserId:(NSString*)userId delegate:(id)delegate;

@end