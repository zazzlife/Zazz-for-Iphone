//
//  FollowRequest.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/22/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface FollowRequest : NSObject

@property Profile* user;
@property NSString* time;

@end
