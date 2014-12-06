//
//  ZazzFollow.m
//  Zazz-iphone-app
//
<<<<<<< HEAD
//  Created by Fyodor Wolf on 10/13/14.
=======
//  Created by Fyodor Wolf on 11/2/14.
>>>>>>> origin/feature/profile-view
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzFollow.h"
#import "ZazzApi.h"
<<<<<<< HEAD
#import "Follow.h"
=======
>>>>>>> origin/feature/profile-view

@implementation ZazzFollow

@synthesize _receivedData;

<<<<<<< HEAD
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
=======
-(void)sendFollowRequest:(NSString*)userId{
    NSString* action = [[NSString alloc] initWithFormat:@"follows/%@",userId];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:nil];
}


@end
>>>>>>> origin/feature/profile-view
