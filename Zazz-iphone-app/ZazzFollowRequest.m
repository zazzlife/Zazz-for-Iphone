//
//  ZazzFollowRequest.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzFollowRequest.h"

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
    NSString* receivedDataString = [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",receivedDataString);
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray* requests = [[NSMutableArray alloc] init];
    
    [self._delegate gotFollowRequests:requests];
}

@end
