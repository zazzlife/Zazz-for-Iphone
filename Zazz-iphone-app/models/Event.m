//
//  Event.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize eventId;
@synthesize name;
@synthesize description;
@synthesize time;
@synthesize utcTime;
@synthesize location;
@synthesize street;
@synthesize city;
@synthesize price;
@synthesize latitude;
@synthesize longitude;
@synthesize createdTime;
@synthesize facebookLink;
@synthesize imageUrl;
@synthesize user;
@synthesize isDateOnly;
@synthesize isFacebookEvent;


+(Event*)makeEventFromDict:(NSDictionary*)event_dict{
    User* user = [[User alloc] init];
    [user setUserId:[event_dict objectForKey:@"userId"]];
    [user setPhotoUrl:[[event_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]];
    [user setUsername:[event_dict objectForKey:@"userDisplayName"]];
    Event* event = [[Event alloc] init];
    [event setEventId:[event_dict objectForKey:@"eventId"]];
    [event setName:[event_dict objectForKey:@"name"]];
    [event setDescription:[event_dict objectForKey:@"description"]];
    [event setTime:[event_dict objectForKey:@"time"]];
    [event setUtcTime:[event_dict objectForKey:@"utcTime"]];
    [event setLocation:[event_dict objectForKey:@"location"]];
    [event setStreet:[event_dict objectForKey:@"street"]];
    [event setCity:[event_dict objectForKey:@"city"]];
    [event setPrice:[event_dict objectForKey:@"price"]];
    [event setLatitude:[event_dict objectForKey:@"latitude"]];
    [event setLongitude:[event_dict objectForKey:@"longitude"]];
    [event setCreatedTime:[event_dict objectForKey:@"createdTime"]];
    [event setFacebookLink:[event_dict objectForKey:@"facebookLink"]];
    [event setImageUrl:[[event_dict objectForKey:@"imageUrl"] objectForKey:@"mediumLink"]];
    [event setIsDateOnly:[[event_dict objectForKey:@"isDateOnly"] boolValue]];
    [event setIsFacebookEvent:[[event_dict objectForKey:@"isFacebookEvent"] boolValue]];
    [event setUser:user];
    return event;
}
@end
