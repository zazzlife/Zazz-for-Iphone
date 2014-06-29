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
#import "ZazzFeed.h"
#import "ZazzCategory.h"
#import "ZazzFollowRequest.h"
#import "ZazzNotification.h"

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
 ME - NOTIFICATIONS
 */
-(void) getNotifications{
    [[[ZazzNotification alloc] init] getNotificationsDelegate:self];
}
-(void) gotNotifications:(NSMutableArray*)notifications{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotNotifications" object:notifications userInfo:nil];
}

/*
 ME - FOLLOW-REQUESTS
 */
-(void) getFollowRequests{
    [[[ZazzFollowRequest alloc] init] getFollowRequestsDelegate:self];
}
-(void) gotFollowRequests:(NSMutableArray*)followRequests{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:followRequests forKey:@"followRequests"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotFollowRequests" object:followRequests userInfo:userInfo];
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
-(void) getFeedCategory:(NSString*)category_id{
    [[[ZazzFeed alloc] init] getFeedCategory:category_id delegate:self];
}
-(void) getFeedCategory:(NSString*)category_id after:(NSString*)last_timestamp{
    [[[ZazzFeed alloc] init] getFeedCategory:category_id after:last_timestamp delegate:self];
}
-(void) gotFeed:(NSMutableArray*)feed{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:feed forKey:@"feed"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotFeed" object:feed userInfo:userInfo];
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

+(NSString*)token_bearer{
    return [NSString stringWithFormat:@"Bearer %@", [AppDelegate zazzApi].auth_token];
}
+(NSMutableURLRequest *)getRequestWithAction:(NSString*)action{
    NSString * api_action =  [[ZazzApi BASE_URL] stringByAppendingString:action];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setValue: [ZazzApi token_bearer] forHTTPHeaderField:@"Authorization"];
    return request;
}

+(NSString*)formatDateString:(NSString*)dateString{
//    NSLog(@"converting: %@",dateString);
    NSMutableArray* parts = [[NSMutableArray alloc] initWithArray:[dateString componentsSeparatedByString:@"."]];
    [parts removeLastObject];
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
    NSLog(@"%@ --> %@ --> %f",utcDate, localDate, difference);
    
    if(difference < 60) return [NSString stringWithFormat:@"%dsec",(int)difference];
    if(difference < 60*60) return [NSString stringWithFormat:@"%dm",(int)difference/(60)];
    if(difference < 60*60*24) return [NSString stringWithFormat:@"%dh",(int)difference/(60*60)];
    return [NSString stringWithFormat:@"%dd",(int)difference/(60*60*24)];
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

+(Post*)makePostFromDict:(NSDictionary*)post_dict{
    Profile* fromUser = [[Profile alloc] init];
    [fromUser setUserId:[post_dict objectForKey:@"fromUserId"]];
    [fromUser setUsername:[post_dict objectForKey:@"fromUserDisplayName"]];
    [fromUser setPhotoUrl:[[post_dict objectForKey:@"fromUserDisplayPhoto"] objectForKey:@"mediumLink"]];
    Post* post = [[Post alloc] init];
    [post setMessage:[post_dict objectForKey:@"message"]];
    [post setTimestamp:[post_dict objectForKey:@"time"]];
    [post setPostId:[post_dict objectForKey:@"postId"]];
    [post setFromUser:fromUser];
    if([post_dict objectForKey:@"toUserId"]){
        Profile* toUser = [[Profile alloc] init];
        [toUser setUserId:[post_dict objectForKey:@"toUserId"]];
        [toUser setUsername:[post_dict objectForKey:@"fromUserDisplayName"]];
        [toUser setPhotoUrl:[[post_dict objectForKey:@"fromUserDisplayPhoto"] objectForKey:@"mediumLink"]];
        [post setToUser:toUser];
    }
    return post;
}
+(Photo*)makePhotoFromDict:(NSDictionary*)photo_dict{
    Profile* user = [[Profile alloc] init];
    [user setUserId:[photo_dict objectForKey:@"userId"]];
    [user setPhotoUrl:[[photo_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]];
    [user setUsername:[photo_dict objectForKey:@"userDisplayName"]];
    Photo* photo = [[Photo alloc] init];
    [photo setDescription:(NSString*)[photo_dict objectForKey:@"description"]];
    [photo setPhotoId:(NSString*)[photo_dict objectForKey:@"photoId"]];
    [photo setPhotoUrl:[[photo_dict objectForKey:@"photoLinks"] objectForKey:@"mediumLink"]];
    [photo setUser:user];
    return photo;
}
+(Event*)makeEventFromDict:(NSDictionary*)event_dict{
    Profile* user = [[Profile alloc] init];
    [user setUserId:[event_dict objectForKey:@"userId"]];
    [user setPhotoUrl:[[event_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]];
    [user setUsername:[event_dict objectForKey:@"userDisplayName"]];
    Event* event = [[Event alloc] init];
    [event setEventId:[event_dict objectForKey:@"eventId"]];
    [event setName:[event_dict objectForKey:@"name"]];
    [event setDescription:[event_dict objectForKey:@"description"]];
    [event setTime:[event_dict objectForKey:@"time"]];
    [event setUtcTime:[event_dict objectForKey:@"utcTime"]];
    [event setLocation:[event_dict objectForKey:@"location"]];
    [event setStreet:[event_dict objectForKey:@"street"]];
    [event setCity:[event_dict objectForKey:@"city"]];
    [event setPrice:[event_dict objectForKey:@"price"]];
    [event setLatitude:[event_dict objectForKey:@"latitude"]];
    [event setLongitude:[event_dict objectForKey:@"longitude"]];
    [event setCreatedTime:[event_dict objectForKey:@"createdTime"]];
    [event setFacebookLink:[event_dict objectForKey:@"facebookLink"]];
    [event setImageUrl:[[event_dict objectForKey:@"imageUrl"] objectForKey:@"mediumLink"]];
    [event setIsDateOnly:[[event_dict objectForKey:@"isDateOnly"] boolValue]];
    [event setIsFacebookEvent:[[event_dict objectForKey:@"isFacebookEvent"] boolValue]];
    [event setUser:user];
    return event;
}

@end
