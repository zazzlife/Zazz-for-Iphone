//
//  ZazzMe.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzMe.h"

@implementation ZazzMe

@synthesize _delegate;

- (void) getMeWithAuthToken:(NSString*)token delegate:(id)delegate{
    
    [self set_delegate:delegate];
    
    NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";
    NSString * api_action =  [BASE_URL stringByAppendingString:@"me"];
    NSString * token_bearer = [NSString stringWithFormat:@"Bearer %@", token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"GET"];
    [request setValue: token_bearer forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    NSString * userId = [array objectForKey:@"userId"];
    [[self _delegate] gotUserId:userId];
}

@end
