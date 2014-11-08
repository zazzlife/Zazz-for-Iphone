//
//  ZAZZCaller.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/8/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "AppDelegate.h"
#import "ZazzApi.h"
#import "ZazzLogin.h"
#import "ZazzProfile.h"
#import "ZazzMe.h"
#import "ZazzFeed.h"
#import "ZazzCategory.h"
#import "ZazzFollowRequest.h"
#import "ZazzFollow.h"
#import "ZazzNotification.h"
#import "ZazzComments.h"
#import "ZazzPost.h"
#import "ZazzPhoto.h"

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
    NSLog(@"Session Token: %@",token);
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:token forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotAuthToken" object:nil userInfo:userInfo];
}


/*
 ME - USER
 */
-(void) getMe{
    [[[ZazzMe alloc] init] getMe];
}
/*
 ME - NOTIFICATIONS
 */
-(void) getNotifications{
    [[[ZazzNotification alloc] init] getNotifications];
}
/*
 ME - FOLLOW-REQUESTS
 */
-(void) getFollowRequests{
    [[[ZazzFollowRequest alloc] init] getFollowRequests];
}
-(void) setFollowRequestsUserId:(NSString*)userId action:(BOOL)action{
    [[[ZazzFollowRequest alloc] init] setFollowRequestsUserId:userId action:action];
    //response neccesary...
}
-(void) sendFollowRequest:(NSString*)userId{
    [[[ZazzFollow alloc] init] sendFollowRequest:userId];
}

/*
PROFILE
 */
-(void) getProfile:(NSString*)profileId{
    [[[ZazzProfile alloc] init] getProfile:profileId];
}
-(void) setProfilePic:(NSString*)photoId{
    [[[ZazzProfile alloc] init] setProfilePic:photoId];
}

/*
 FEED
 */
-(void) getFeed{
    [[[ZazzFeed alloc] init] getMyFeed];
}
-(void) getFeedAfter:(NSString*)feed_id{
    [[[ZazzFeed alloc] init] getMyFeedAfter:feed_id];
}
-(void) getFeedCategory:(NSString*)category_id{
    [[[ZazzFeed alloc] init] getFeedCategory:category_id];
}
-(void) getFeedCategory:(NSString*)category_id after:(NSString*)last_timestamp{
    [[[ZazzFeed alloc] init] getFeedCategory:category_id after:last_timestamp];
}

-(void) getUserFeed:(NSString*)user_id{
    [[[ZazzFeed alloc] init] getUserFeed:user_id];
}
-(void) getUserFeed:(NSString*)user_id after:(NSString*)feed_id{
    [[[ZazzFeed alloc] init] getUserFeed:user_id after:feed_id];
}

/*
 CATEGORIES
 */
-(void) getCategories{
    [[[ZazzCategory alloc] init] getCategories];
}

/*
 COMMENTS
 */
-(void) getCommentsFor:(NSString *)feedType andId:(NSString *)feedId{
    [[[ZazzComments alloc] init] getCommentsFor:feedType andId:feedId];
}


/*
 PUT ACTIONS
 */
-(void)postPost:(Post*)post{
    [[[ZazzPost alloc] init] postPost:post];
}
-(void)postPhoto:(Photo*)photo{
    [[[ZazzPhoto alloc] init] postPhoto:photo];
}





//STATIC METHODS

+(NSString*)token_bearer
{
    return [NSString stringWithFormat:@"Bearer %@", [AppDelegate zazzApi].auth_token];
}
+(NSMutableURLRequest *)getRequestWithAction:(NSString*)action{
    NSString * api_action =  [[ZazzApi BASE_URL] stringByAppendingString:action];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setValue: [ZazzApi token_bearer] forHTTPHeaderField:@"Authorization"];
    return request;
}
+(NSString*)formatDateString:(NSString*)dateString
{
    NSMutableArray* parts = [[NSMutableArray alloc] initWithArray:[dateString componentsSeparatedByString:@"."]];
    if ([parts count]>1)[parts removeLastObject];
    NSString* fixedDateString = [parts componentsJoinedByString:@"."];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
   
    //create Date string w/ utc timezone
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate* utcDate = [df dateFromString:fixedDateString];
    
    //convert utcDate to localDate
    [df setTimeZone:[NSTimeZone localTimeZone]];
    NSDate* localDate = [df dateFromString:[df stringFromDate:utcDate]];
    
    //get the difference
    NSTimeInterval difference = [localDate timeIntervalSinceNow] * -1;
    
    if(difference < 60) return [NSString stringWithFormat:@"%d second%@ ago",(int)difference, (int)difference > 1? @"s" : @""];
    if(difference < 60*60) return [NSString stringWithFormat:@"%d minute%@ ago",(int)difference/(60), (int)difference/(60) > 1? @"s" : @""];
    if(difference < 60*60*24) return [NSString stringWithFormat:@"%d hour%@ ago",(int)difference/(60*60), (int)difference/(60*60) > 1? @"s" : @""];
    if(difference < 60*60*24*30) return [NSString stringWithFormat:@"%d day%@ ago",(int)difference/(60*60*24), (int)difference/(60*60*24) > 1? @"s" : @""];
    if(difference < 60*60*24*365) return [NSString stringWithFormat:@"%d month%@ ago",(int)difference/(60*60*24*30), (int)difference/(60*60*24*30) > 1? @"s" : @""];
    return [NSString stringWithFormat:@"%d year%@ ago",(int)difference/(60*60*24*365), (int)difference/(60*60*24*365)>1?@"s":@"" ];
}
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
+(NSString *) BASE_URL{ return @"http://www.zazzlife.com/api/v1/"; }

@end
