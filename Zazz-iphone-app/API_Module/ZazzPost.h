//
//  ZazzPost.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface ZazzPost : NSObject<NSURLConnectionDataDelegate>

@property NSMutableData* _receivedData;
-(void)postPost:(Post*)post;

@end
