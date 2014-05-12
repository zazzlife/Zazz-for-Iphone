//
//  ZazzLogin.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzLogin.h"

@implementation ZazzLogin

@synthesize _delegate;

- (void) loginWithUsername:(NSString*)username andPassword:(NSString*)password delegate:(id)delegate{
    
    [self set_delegate:delegate];
    
    NSString *api_action =  [[ZazzApi BASE_URL] stringByAppendingString:@"token"];
    NSMutableDictionary * form = [[NSMutableDictionary alloc] init];
    [form setObject:@"grant_type" forKey:@"password"];
    [form setObject:@"username" forKey:username];
    [form setObject:@"password" forKey:password];
    [form setObject:@"scope" forKey:@"full"];
    NSString *postString = [ZazzApi getQueryStringFromDictionary:form];
//    NSLog(@"ZazzLogin - postString:%@",postString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic hdi7o53NSeilrq7oQihy69PvH9BBQtw5QfcJy4ALBuY" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setValue:[NSString   stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
//    if([array objectForKey:@"error"]){
//        NSLog(@"Invalid login");
//    }
    [[self _delegate] gotLoginToken:[array objectForKey:@"access_token"]];
}


@end
