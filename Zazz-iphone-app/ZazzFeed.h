//
//  ZazzFeed.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"

@interface ZazzFeed : NSObject<NSURLConnectionDataDelegate>

@property ZazzApi* _delegate;

- (void) getMyFeedDelegate:(id)delegate;
- (void) getFeedForUserId:(NSString*)userId delegate:(id)delegate;

@end
