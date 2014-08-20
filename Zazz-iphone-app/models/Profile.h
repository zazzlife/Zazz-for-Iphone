//
//  Profile.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property NSString* userId;
@property BOOL is_public;
@property NSString* accountType;
@property BOOL isConfirmed;
@property NSString* username;
@property UIImage* photo;
@property NSString* photoUrl;

@property BOOL isFullProfile;


+(Profile*)makeProfileFromDict:(NSDictionary*)profile_dict;

@end
