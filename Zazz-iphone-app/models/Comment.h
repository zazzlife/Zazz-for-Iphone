//
//  Comment.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface Comment : NSObject

@property NSString* commentId;
@property Profile* user;
@property NSString* commentText;
@property BOOL isFromCurrentUser;
@property NSString* time;

@end
