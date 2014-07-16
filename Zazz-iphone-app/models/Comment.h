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

extern const NSString* COMMENT_TYPE_PHOTO;
extern const NSString* COMMENT_TYPE_POST;
extern const NSString* COMMENT_TYPE_EVENT;

@property NSString* commentId;
@property Profile* user;
@property NSString* commentText;
@property BOOL isFromCurrentUser;
@property NSString* time;

+(Comment*)makeCommentFromDict:(NSDictionary*)comment_dict;

@end
