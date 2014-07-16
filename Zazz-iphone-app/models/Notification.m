//
//  Notification.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Notification.h"
#import "Photo.h"
#import "Post.h"
#import "Event.h"

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

+
(Notification*)makeNotificationWithDict:(NSDictionary*)notif_dict{
    Profile* user = [[Profile alloc] init];
    [user setUserId:[notif_dict objectForKey:@"userId"]];
    [user setUsername:[notif_dict objectForKey:@"displayName"]];
    [user setPhotoUrl:[[notif_dict objectForKey:@"displayPhoto"] objectForKey:@"originalLink"]];
    
    Notification* notification = [[Notification alloc] init];
    [notification setUser:user];
    [notification setTime:[notif_dict objectForKey:@"time"]];
    [notification setNotificationTypeWithString:[notif_dict objectForKey:@"notificationType"]];
    [notification setIsRead:[notif_dict objectForKey:@"isRead"]];
    [notification setNotificationId:[notif_dict objectForKey:@"notificationId"]];
    if([notification notificationType] == CommentOnPhoto){
        Photo* photo = [Photo makePhotoFromDict:[notif_dict objectForKey:@"photo"]];
        [notification setContent:photo];
    }
    else if([notification notificationType] == CommentOnPost || [notification notificationType]  == WallPost){
        Post* post = [Post makePostFromDict:[notif_dict objectForKey:@"post"]];
        [notification setContent:post];
    }
    else if([notification notificationType] == CommentOnEvent || [notification notificationType] == NewEvent){
        Event* event = [Event makeEventFromDict:[notif_dict objectForKey:@"apiEvent"]];//THIS WILL NEED TO BE FIXED FOR API V2
        [notification setContent:event];
    }
    return notification;
}

@end
