//
//  ZazzNotification.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"

@interface ZazzNotification : NSObject

@property NSMutableData* _receivedData;

-(void)getNotifications;

@end
