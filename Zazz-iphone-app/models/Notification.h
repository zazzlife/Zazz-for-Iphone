//
//  Notification.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"


#define FollowRequestAccepted 0
#define CommentOnPhoto 1
#define CommentOnPost 2
#define WallPost 3
#define CommentOnEvent 4
#define NewEvent 5

@interface Notification : NSObject

@property NSString* notificationId;
@property Profile* user;
@property BOOL isRead;
@property NSString* time;
@property id content;
@property int notificationType;

-(void)setNotificationTypeWithString:(NSString*)notificationString;

@end
