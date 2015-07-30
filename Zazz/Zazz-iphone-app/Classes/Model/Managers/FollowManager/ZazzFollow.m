//
//  ZazzFollow.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/13/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzFollow.h"
#import "ZazzApi.h"
#import "Follow.h"

@implementation ZazzFollow

@synthesize _receivedData;

-(void)getFollows{
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:@"follows"];
    NSLog(@"curl %@ -X %@ -H \"Authorization:%@\" ",
          request.URL,
          request.HTTPMethod,
          [request valueForHTTPHeaderField:@"Authorization"]
          );
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError* error = nil;
    NSString *myString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"received: %@",myString);
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:_receivedData options:0 error:&error ];
    if(array == nil){
        NSString *myString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON ERROR: %@, DATA: %@", error,myString);
    }
    NSMutableArray* follows = [[NSMutableArray alloc] init];
    for(NSDictionary* follow_dict in array){
        [follows addObject:[Follow makeFollowFromDict:[NSMutableDictionary dictionaryWithDictionary:follow_dict]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotFollows" object:follows userInfo:nil];
}

@end
