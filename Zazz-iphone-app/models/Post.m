//
//  Post.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Post.h"

@implementation Post

+(Post*)makePostFromDict:(NSDictionary*)post_dict{
    Profile* fromUser = [[Profile alloc] init];
    [fromUser setUserId:[post_dict objectForKey:@"fromUserId"]];
    [fromUser setUsername:[post_dict objectForKey:@"fromUserDisplayName"]];
    [fromUser setPhotoUrl:[[post_dict objectForKey:@"fromUserDisplayPhoto"] objectForKey:@"mediumLink"]];
    Post* post = [[Post alloc] init];
    NSString* message = @"";
    for(NSDictionary* message_parts in [post_dict objectForKey:@"message"]){
        NSString* message_text_part = [message_parts objectForKey:@"text"];
        if([[message_parts objectForKey:@"clubId"] intValue] > 0){
            NSLog(@"TODO link-to %@", message_text_part);
        }
        message = [message stringByAppendingString:message_text_part];
    }
    [post setMessage:message];
    [post setTimestamp:[post_dict objectForKey:@"time"]];
    [post setPostId:[post_dict objectForKey:@"postId"]];
    [post setCategories:[post_dict objectForKey:@"categories"]];
    [post setFromUser:fromUser];
    if([post_dict objectForKey:@"toUserId"]){
        Profile* toUser = [[Profile alloc] init];
        [toUser setUserId:[post_dict objectForKey:@"toUserId"]];
        [toUser setUsername:[post_dict objectForKey:@"fromUserDisplayName"]];
        [toUser setPhotoUrl:[[post_dict objectForKey:@"fromUserDisplayPhoto"] objectForKey:@"mediumLink"]];
        [post setToUser:toUser];
    }
    return post;
}

@end
