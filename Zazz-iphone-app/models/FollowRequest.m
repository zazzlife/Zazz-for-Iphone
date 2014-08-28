//
//  FollowRequest.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/22/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FollowRequest.h"

@implementation FollowRequest

@synthesize user;
@synthesize time;

+(FollowRequest*)makeFollowRequestFromDict:(NSDictionary*)request_dict{
    FollowRequest* request = [[FollowRequest alloc] init];
    User* user = [[User alloc] init];
    [user setUserId:[request_dict objectForKey:@"userId"]];
    [user setUsername:[request_dict objectForKey:@"displayName"]];
    [user setPhotoUrl:[[request_dict objectForKey:@"displayPhoto"] objectForKey:@"originalLink"]];
    [request setUser:user];
    [request setTime:[request_dict objectForKey:@"time"]];
    return request;
}

@end
