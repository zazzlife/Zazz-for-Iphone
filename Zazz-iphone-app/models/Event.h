//
//  Event.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface Event : NSObject

@property NSString* eventId;
@property NSString* name;
@property NSString* description;
@property NSString* time;
@property NSString* utcTime;
@property NSString* location;
@property NSString* street;
@property NSString* city;
@property NSString* price;
@property NSString* latitude;
@property NSString* longitude;
@property NSString* createdTime;
@property NSString* facebookLink;
@property NSString* imageUrl;
@property Profile* user;
@property BOOL isDateOnly;
@property BOOL isFacebookEvent;


+(Event*)makeEventFromDict:(NSDictionary*)event_dict;

@end
