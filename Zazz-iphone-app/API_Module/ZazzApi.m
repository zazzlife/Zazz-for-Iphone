//
//  ZAZZCaller.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/8/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzApi.h"
#import "ZazzLogin.h"
#import "ZazzProfile.h"
#import "ZazzFeed.h"

static NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";

@implementation ZazzApi

+(NSString *) BASE_URL{  return BASE_URL; }
@synthesize auth_token;
@synthesize _delegate;

-(id) init{
    [self setAuth_token:nil];
    return [super init];
}



/*
 LOGIN
 */

-(BOOL) needAuth {
    return self.auth_token == nil;
}
-(void) getAuthTokenWithUsername:(NSString*)username andPassword:(NSString*)password delegate:(id)delegate{
    [self set_delegate:delegate];
    [[[ZazzLogin alloc] init] loginWithUsername:username andPassword:password delegate:self];
}
-(void) gotLoginToken:(NSString*)token{
    [self setAuth_token:token];
    [_delegate finishedZazzAuth:![self needAuth]];
}



/*
 ME - PROFILE
 */
-(void) getMyProfileDelegate:(id)delegate{
    [[[ZazzProfile alloc] init] getMyProfileDelegate:self];
}
-(void) getProfile:(NSString*)userId delegate:(id)delegate{
    
}
-(void) gotProfile:(Profile*)profile{
    [_delegate gotZazzProfile:profile];
}


/*
 FEED
 */
-(void) getFeed:(NSString*)userId delegate:(id)delegate{
    [[[ZazzFeed alloc] init] getFeedForUserId:userId delegate:self];
}
-(void) gotFeed:(Feed*)feed{
    NSLog(@"TODO: CHANGE METHOD SIGNATURE TO ACCEPT Feed OBJECT. feed:%@", feed);
    [_delegate gotZazzFeed:feed];
}




//STATIC METHODS
+(NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}
+(NSString*)getQueryStringFromDictionary:(NSDictionary *)dictionary
{
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:@""];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:valueString], [self urlEscapeString:keyString]];
    }
    return urlWithQuerystring;
}


@end
