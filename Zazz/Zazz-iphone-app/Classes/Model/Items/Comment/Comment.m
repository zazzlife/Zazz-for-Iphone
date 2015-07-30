//
//  Comment.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Comment.h"

@implementation Comment

const NSString* COMMENT_TYPE_PHOTO = @"photo";
const NSString* COMMENT_TYPE_POST = @"post";
const NSString* COMMENT_TYPE_EVENT = @"event";

@synthesize commentId;
@synthesize user;
@synthesize text;
@synthesize isFromCurrentUser;
@synthesize time;

+(Comment*)makeCommentFromDict:(NSDictionary*)comment_dict{
    User* fromUser = [[User alloc] init];
    [fromUser setUsername:[comment_dict objectForKey:@"userDisplayName"]];
    [fromUser setPhotoUrl:[[comment_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]];
    [fromUser setUserId:[comment_dict objectForKey:@"userId"]];
    Comment* comment = [[Comment alloc] init];
    [comment setUser:fromUser];
    [comment setTime:[comment_dict objectForKey:@"time"]];
    [comment setText:[comment_dict objectForKey:@"commentText"]];
    [comment setIsFromCurrentUser:[[comment_dict objectForKey:@"isFromCurrentUser"] boolValue]];
    return comment;
}

@end
