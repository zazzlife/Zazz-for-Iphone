//
//  ZazzSendFollow.h
//  Zazz-iphone-app
//
//  Created by Serdar ÇINAR on 10/12/14.
//  Copyright (c) 2014 Hasan Serdar ÇINAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"

@interface ZazzSendFollow : NSObject<NSURLConnectionDataDelegate>

@property NSMutableData* _receivedData;

-(void)setUserToFollow:(NSString*)userId action:(BOOL)follow;

@end
