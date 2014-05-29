//
//  ZazzMe.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzProfile.h"
#import "UIImage.h"

@implementation ZazzProfile

@synthesize _delegate;

- (void) getMyProfileDelegate:(id)delegate{
    
    [self set_delegate:delegate];
    
    NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";
    NSString * api_action =  [BASE_URL stringByAppendingString:@"me"];
    NSString * token_bearer = [NSString stringWithFormat:@"Bearer %@", [delegate auth_token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"GET"];
    [request setValue: token_bearer forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}
-(void) getProfile:(NSString *)userId delegate:(id)delegate{
    NSLog(@"TODO; IMPLEMENT GET PROFILE WITH USERID - ZazzProfile:getProfile");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    Profile* profile = [[Profile alloc] init];
    [profile setUserId:[array objectForKey:@"userId"]];
    [profile setAccountType:[array objectForKey:@"accountType"]];
    [profile setIsConfirmed:[array objectForKey:@"isConfirmed"]];
    [profile setUsername:[array objectForKey:@"displayName"]];
    [profile setPhoto:[UIImage getImageAtUrl:[(NSDictionary*)[array objectForKey:@"displayPhoto"] objectForKey:@"mediumLink"]]];
    
    [[self _delegate] gotProfile:profile];
}

@end
