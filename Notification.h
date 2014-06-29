//
//  Notification.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface Notification : NSObject

@property NSString* notificationId;
@property Profile* user;
@property NSString* notificationType;
@property BOOL isRead;
@property NSString* time;
@property id content;

@end
