    //
//  ZazzPost.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzPost.h"
#import "ZazzApi.h"
#import "Post.h"

@implementation ZazzPost

NSMutableData* _receivedData = nil;

-(void)postPost:(Post*)post{
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:@"posts"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary* text = [[NSMutableDictionary alloc] init];
    [text setObject:post.message forKey:@"Text"];
    NSMutableArray* message = [[NSMutableArray alloc] init];
    [message addObject:text];
    NSMutableDictionary* form = [[NSMutableDictionary alloc] init];
    [form setObject:message forKey:@"Message"];
    [form setObject:post.categories forKey:@"Categories"];
    
    NSData* json = [NSJSONSerialization dataWithJSONObject:form options:0 error:nil];
    
    [request setHTTPBody:json];
    NSLog(@"curl %@ -X %@ -H \"Authorization:%@\" -H \"Content-Type:%@\" -d '%@' ",
          request.URL,
          request.HTTPMethod,
          [request valueForHTTPHeaderField:@"Authorization"],
          [request valueForHTTPHeaderField:@"Content-Type"],
          [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]
    );
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(_receivedData == nil){
        _receivedData = [[NSMutableData alloc] init];
    }
    [_receivedData appendData:data];
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
    Post* post = [Post makePostFromDict:array];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"madePost" object:post userInfo:nil];
}



@end
