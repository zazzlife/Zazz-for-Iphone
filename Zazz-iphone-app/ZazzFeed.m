//
//  ZazzFeed.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzFeed.h"

@implementation ZazzFeed

@synthesize _delegate;


- (void) getMyFeedDelegate:(ZazzApi*)delegate{
    [self set_delegate:delegate];
    
    NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";
    NSString * api_action =  [BASE_URL stringByAppendingString:@""];
    NSString * token_bearer = [NSString stringWithFormat:@"Bearer %@", [delegate auth_token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"GET"];
    [request setValue: token_bearer forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) getFeedForUserId:(NSString *)userId delegate:(id)delegate{
    
    [self set_delegate:delegate];
    
    NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";
    NSString * api_action =  [BASE_URL stringByAppendingString:@""];
    NSString * token_bearer = [NSString stringWithFormat:@"Bearer %@", [delegate auth_token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"GET"];
    [request setValue: token_bearer forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString* feed = @"";
    [[self _delegate] gotFeed:feed];
}

@end
