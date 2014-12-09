//
//  UserDetails.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/27/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "UserDetails.h"

@implementation UserDetails

@synthesize fullName;
@synthesize city;
@synthesize major;
@synthesize school;
@synthesize gender;

+(UserDetails*)makeUserDetailsFromDict:(NSDictionary*)details_dict{
    UserDetails* user = [[UserDetails alloc] init];
    [user setFullName:[details_dict objectForKey:@"fullName"]];
    [user setGender:[NSString stringWithFormat:@"%@",[details_dict objectForKey:@"gender"]]];
    [user setSchool:[GenericModel makeGenericModelFromDict:[details_dict objectForKey:@"school"]]];
    [user setCity:[GenericModel makeGenericModelFromDict:[details_dict objectForKey:@"city"]]];
    [user setMajor:[GenericModel makeGenericModelFromDict:[details_dict objectForKey:@"major"]]];
    return user;
}

@end
