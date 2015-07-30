//
//  User.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/22/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetails.h"

@interface Profile : NSObject

@property NSString* profile_id;
@property NSString* accountType;
@property NSString* displayName;
@property NSString* photoUrl;
@property UIImage* image;
@property NSString* followersCount;
@property NSMutableArray* feeds;
@property NSMutableArray* photos;
@property NSMutableArray* weeklies;
@property UserDetails* userDetails;
//@property ClubDetails* clubDetails;
@property BOOL followRequestAlreadySent;
@property BOOL isSelf;
@property BOOL isCurrentUserFollowingTargetUser;
@property BOOL isTargetUserFollowingCurrentUser;

+(Profile*)makeProfileFromDict:(NSDictionary*)profile_dict;

@end
