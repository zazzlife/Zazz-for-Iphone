//
//  ZazzRegister.m
//  Zazz-iphone-app
//
//  Created by Serdar ÇINAR on 09/12/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzRegister.h"

@implementation ZazzRegister
@synthesize _delegate;

-(void)registerWithDict:(NSDictionary *)dict delegate:(id)delegate {
    
    [self set_delegate:delegate];
    
    NSString *api_action =  [[ZazzApi BASE_URL] stringByAppendingString:@"register"];
    NSMutableDictionary * form = [[NSMutableDictionary alloc] init];
    [form addEntriesFromDictionary:dict];
    NSString *postString = [ZazzApi getQueryStringFromDictionary:form];
    NSLog(@"%@", postString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic hdi7o53NSeilrq7oQihy69PvH9BBQtw5QfcJy4ALBuY" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu",[postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
    if(array == nil){
        [[self _delegate] gotAuthError:[array objectForKey:@"error"]];
        NSLog(@"JSON ERROR");
        return;
    }
    NSLog(@"%@", array);
    NSString* access_token = [array objectForKey:@"access_token"];
    if(access_token == nil){
        [[self _delegate] gotAuthError:[array objectForKey:@"error"]];
        return;
    }
    [[self _delegate] gotAuthToken:access_token];
}

@end
