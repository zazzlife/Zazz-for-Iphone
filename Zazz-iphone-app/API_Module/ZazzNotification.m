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

-(void)getNotificationsDelegate:(id)delegate{
    [self set_delegate:delegate];
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
            Photo* photo = [ZazzApi makePhotoFromDict:[notif_dict objectForKey:@"photo"]];
            [notification setContent:photo];
        }
        else if([notification notificationType] == CommentOnPost || [notification notificationType]  == WallPost){
            Post* post = [ZazzApi makePostFromDict:[notif_dict objectForKey:@"post"]];
            [notification setContent:post];
        }
        else if([notification notificationType] == CommentOnEvent || [notification notificationType] == NewEvent){
            Event* event = [ZazzApi makeEventFromDict:[notif_dict objectForKey:@"apiEvent"]];//THIS WILL NEED TO BE FIXED FOR API V2
            [notification setContent:event];
        }
        
        [notifications addObject:notification];
    }
    
    [self._delegate gotNotifications:notifications];
}


@end
