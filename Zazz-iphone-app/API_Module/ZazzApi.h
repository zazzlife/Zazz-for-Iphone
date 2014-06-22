//
//  ZAZZCaller.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/8/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"
#import "Feed.h"

@interface ZazzApi: NSObject

@property NSString* auth_token;

+(NSString *) BASE_URL;
+(NSString *) token_bearer;
+(NSString *) urlEscapeString:(NSString *)unencodedString;
+(NSString *) getQueryStringFromDictionary:(NSDictionary *)dictionary;
+(NSMutableURLRequest *)getRequestWithAction:(NSString*)action;

-(BOOL) needAuth;
-(void) getAuthTokenWithUsername:(NSString*)username andPassword:(NSString*)password;
-(void) gotAuthError:(NSString*)error;
-(void) gotAuthToken:(NSString*)token;

-(void) getMyProfile;
//-(void) getProfile:(NSString*)userId;
-(void) gotProfile:(Profile*)profile;

-(void) getFollowRequests;
-(void) gotFollowRequests:(NSMutableArray*)followRequests;

-(void) getFeed;
-(void) getFeedAfter:(NSString*)last_timestamp;
-(void) getFeedCategory:(NSString*)category_id;
-(void) getFeedCategory:(NSString*)category_id after:(NSString*)last_timestamp;
-(void) gotFeed:(NSMutableArray*)feed;

-(void) getCategories;
-(void) gotCategories:(NSMutableArray*)categories;

@end
