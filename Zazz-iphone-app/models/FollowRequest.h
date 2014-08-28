//
//  FollowRequest.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/22/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface FollowRequest : NSObject

@property User* user;
@property NSString* time;

+(FollowRequest*)makeFollowRequestFromDict:(NSDictionary*)request_dict;

@end
