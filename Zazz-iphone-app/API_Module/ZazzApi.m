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

static NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";

@implementation ZazzApi

+(NSString *) BASE_URL{  return BASE_URL; }
@synthesize auth_token;

NSMutableDictionary* _delegates;



-(id) init{
    [self setAuth_token:nil];
    _delegates = [[NSMutableDictionary alloc ] init];
    return [super init];
}

/*
 LOGIN
 */

-(BOOL) needAuth {
    return self.auth_token == nil;
}
-(void) getAuthTokenWithUsername:(NSString*)username andPassword:(NSString*)password delegate:(id)delegate{
    [_delegates setObject:delegate forKey:@"auth"];
    [[[ZazzLogin alloc] init] loginWithUsername:username andPassword:password delegate:self];
}
-(void) gotLoginToken:(NSString*)token{
    [self setAuth_token:token];
    [[_delegates objectForKey:@"auth"] finishedZazzAuth:![self needAuth]];
    [_delegates removeObjectForKey:@"auth"];
}



/*
 ME - PROFILE
 */
-(void) getMyProfileDelegate:(id)delegate{
    [_delegates setObject:delegate forKey:@"profile"];
    [[[ZazzProfile alloc] init] getMyProfileDelegate:self];
}
-(void) getProfile:(NSString*)userId delegate:(id)delegate{
    [_delegates setObject:delegate forKey:@"profile"];
    [[[ZazzProfile alloc] init] getProfile:userId delegate:delegate];
}
-(void) gotProfile:(Profile*)profile{
    [[_delegates objectForKey:@"profile"] gotZazzProfile:profile];
    [_delegates removeObjectForKey:@"profile"];

}


/*
 FEED
 */
-(void) getMyFeedDelegate:(id)delegate{
    [_delegates setObject:delegate forKey:@"feed"];
    [[[ZazzFeed alloc] init] getMyFeedDelegate:self];
}
-(void) getMyFeedAfter:(NSString*)last_timestamp delegate:(id)delegate{
    [_delegates setObject:delegate forKey:@"feed"];
    [[[ZazzFeed alloc] init] getMyFeedAfter:last_timestamp delegate:self];
}
-(void) gotFeed:(NSMutableArray*)feedArray{
    [[_delegates objectForKey:@"feed"] gotZazzFeed:feedArray];
    [_delegates removeObjectForKey:@"feed"];
}


/*
 CATEGORIES
 */
-(void) getCategories:(id)delegate{
    [_delegates setObject:delegate forKey:@"category"];
    [[[ZazzCategory alloc] init] getCategoriesDelegate:self];
}
-(void) gotCategories:(NSMutableArray*)categories{
    [[_delegates objectForKey:@"category"] gotZazzCategories:categories];
    [_delegates removeObjectForKey:@"category"];
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
