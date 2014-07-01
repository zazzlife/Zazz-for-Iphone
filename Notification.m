//
//  Notification.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Notification.h"

@implementation Notification

@synthesize notificationId;
@synthesize user;
@synthesize isRead;
@synthesize time;
@synthesize content;
@synthesize notificationType;

-(void)setNotificationTypeWithString:(NSString*)notificationString{
    if([notificationString isEqualToString:@"FollowRequestAccepted"]){
        self.notificationType = FollowRequestAccepted;
        return;
    }
    else if([notificationString isEqualToString:@"CommentOnPhoto"]){
        self.notificationType = CommentOnPhoto;
        return;
    }
    else if([notificationString isEqualToString:@"CommentOnPost"]){
        self.notificationType = CommentOnPost;
        return;
    }
    else if([notificationString isEqualToString:@"WallPost"]){
        self.notificationType = WallPost;
        return;
    }
    else if([notificationString isEqualToString:@"CommentOnEvent"]){
        self.notificationType = CommentOnEvent;
        return;
    }
    else if([notificationString isEqualToString:@"NewEvent"]){
        self.notificationType = NewEvent;
        return;
    }
}

@end
