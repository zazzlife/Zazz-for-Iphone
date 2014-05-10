//
//  ZAZZCaller.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/8/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzApi.h"
#import "ZazzLogin.h"
#import "ZazzMe.h"

static NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";

@implementation ZazzApi

+(NSString *) BASE_URL{  return BASE_URL; }
@synthesize auth_token;

-(id) init{
    [self setAuth_token:nil];
    return [super init];
}

-(BOOL) needAuth {  return self.auth_token == nil; }


/*
 LOGIN
 */
- (void) doLoginWithUsername:(NSString*)username andPassword:(NSString*)password{
    ZazzLogin * loginCaller = [[ZazzLogin alloc] init];
    [loginCaller loginWithUsername:username andPassword:password withDelegate:self];
}
-(void) gotLoginToken:(NSString*)token{
    [self setAuth_token:token];
    
    NSLog(@"TODO: REMOVE AND SEPORATE INTO LOGIN / POST LOGIN SCREENS...");
    [self getMe];
}



/*
 ME - PROFILE
 */
-(void) getMe{
    [[[ZazzMe alloc] init] getMeWithAuthToken:auth_token delegate:self];
}
-(void) gotUserId:(NSString*)userId{
    NSLog(@"Got UserId: %@",userId);
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
