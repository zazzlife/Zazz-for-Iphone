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

-(void)getFollowRequests{
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:@"followrequests"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)setFollowRequestsUserId:(NSString*)userId action:(BOOL)accepted{
    NSString* action = [NSString stringWithFormat:@"followrequests/%@?action=%@",userId, accepted?@"accept":@"reject"];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [request setHTTPMethod:@"DELETE"];
    [NSURLConnection connectionWithRequest:request delegate:nil];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:self._receivedData options:0 error:nil ];
//    NSLog(@"%@",  [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding]);
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray* requests = [[NSMutableArray alloc] init];
    for(NSDictionary* request_dict in array){
        FollowRequest* request = [FollowRequest makeFollowRequestFromDict:request_dict];
        [requests addObject:request];
    }
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:requests forKey:@"followRequests"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotFollowRequests" object:requests userInfo:userInfo];
}

@end
