//
//  Follow.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/13/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Follow.h"

@implementation Follow

@synthesize userId;
@synthesize displayName;
@synthesize displayPhoto;

+(Follow*)makeFollowFromDict:(NSMutableDictionary *)follow_dict{
    Follow* follow = [[Follow alloc] init];
    [follow setUserId:[follow_dict objectForKey:@"userId"]];
    [follow setDisplayName:[follow_dict objectForKey:@"displayName"]];
    [follow setDisplayPhoto:[Photo makePhotoFromDict:[follow_dict objectForKey:@"displayPhoto"]]];
    return follow;
}

@end
