//
//  ZazzFollowRequest.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"

@interface ZazzFollowRequest : NSObject

@property NSMutableData* _receivedData;

-(void)getFollowRequests;
-(void)setFollowRequestsUserId:(NSString*)userId action:(BOOL)accepted;


@end
