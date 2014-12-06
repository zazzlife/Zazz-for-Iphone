//
//  ZazzFollow.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 11/2/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZazzFollow : NSObject<NSURLConnectionDataDelegate>

@property NSMutableData* _receivedData;

-(void)sendFollowRequest:(NSString*)userId;

@end