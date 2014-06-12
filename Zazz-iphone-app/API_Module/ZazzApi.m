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
#import "ZazzCategory.h"

@implementation ZazzApi

@synthesize auth_token;


/*
 LOGIN
 */

-(BOOL) needAuth {
    return self.auth_token == nil;
}
-(void) getAuthTokenWithUsername:(NSString*)username andPassword:(NSString*)password{
    [[[ZazzLogin alloc] init] loginWithUsername:username andPassword:password delegate:self];
}
-(void)gotAuthError:(NSString*)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotAuthError" object:nil];
}
-(void) gotAuthToken:(NSString*)token{
    [self setAuth_token:token];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:token forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotAuthToken" object:nil userInfo:userInfo];
}



/*
 ME - PROFILE
 */
-(void) getMyProfile{
    [[[ZazzProfile alloc] init] getMyProfileDelegate:self];
}
//-(void) getProfile:(NSString*)userId{
//    [[[ZazzProfile alloc] init] getMyProfileDelegate:<#(id)#>];
//}
-(void) gotProfile:(Profile*)profile{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotMyProfile" object:profile userInfo:nil];
}


/*
 FEED
 */
-(void) getFeed{
    [[[ZazzFeed alloc] init] getMyFeedDelegate:self];
}
-(void) getFeedAfter:(NSString*)feedId{
    [[[ZazzFeed alloc] init] getMyFeedAfter:feedId delegate:self];
}
-(void) gotFeed:(NSMutableArray*)feed{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:feed forKey:@"feed"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotFeed" object:nil userInfo:userInfo];
}


/*
 CATEGORIES
 */
-(void) getCategories{
    [[[ZazzCategory alloc] init] getCategoriesDelegate:self];
}
-(void) gotCategories:(NSMutableArray*)categories{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:categories forKey:@"categories"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotCategories" object:nil userInfo:userInfo];
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
+(NSString *) BASE_URL{ return @"http://test.zazzlife.com/api/v1/"; }


@end
