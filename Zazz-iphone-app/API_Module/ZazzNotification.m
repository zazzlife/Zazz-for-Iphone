//
//  ZazzNotification.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzNotification.h"
#import "Notification.h"
#import "Profile.h"
#import "Photo.h"
#import "Post.h"
#import "Event.h"

@implementation ZazzNotification

-(void)getNotifications{
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:@"notifications"];
//    NSLog(@"norifURL: %@",[request URL] );
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:self._receivedData options:0 error:nil ];
    NSString* receivedDataString = [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"NOTIFICATION: %@",receivedDataString);
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray* notifications = [[NSMutableArray alloc] init];
    for(NSDictionary* notif_dict in array){
        Notification* notification = [Notification makeNotificationWithDict:notif_dict];
        [notifications addObject:notification];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotNotifications" object:notifications userInfo:nil];
}


@end
