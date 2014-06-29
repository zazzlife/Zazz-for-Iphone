//
//  ZazzFollowRequest.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzFollowRequest.h"
#import "FollowRequest.h"
#import "Profile.h"

@implementation ZazzFollowRequest

-(void)getFollowRequestsDelegate:(id)delegate{
    [self set_delegate:delegate];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:@"followrequests"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:self._receivedData options:0 error:nil ];
//    NSLog(@"%@",[[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding]);
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray* requests = [[NSMutableArray alloc] init];
    for(NSDictionary* request_dict in array){
        FollowRequest* request = [[FollowRequest alloc] init];
        Profile* user = [[Profile alloc] init];
        [user setUserId:[request_dict objectForKey:@"userId"]];
        [user setUsername:[request_dict objectForKey:@"displayName"]];
        [user setPhotoUrl:[[request_dict objectForKey:@"displayPhoto"] objectForKey:@"originalLink"]];
        [request setUser:user];
        [request setTime:[request_dict objectForKey:@"time"]];
        [requests addObject:request];
    }
    
    [self._delegate gotFollowRequests:requests];
}

@end
