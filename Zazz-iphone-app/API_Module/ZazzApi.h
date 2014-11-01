//
//  ZAZZCaller.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/8/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"
#import "Comment.h"
#import "Post.h"
#import "Event.h"
#import "Photo.h"
#import "Feed.h"

@interface ZazzApi: NSObject

@property NSString* auth_token;

+(NSString *) BASE_URL;
+(NSString *) token_bearer;
+(NSString *) urlEscapeString:(NSString *)unencodedString;
+(NSString *) getQueryStringFromDictionary:(NSDictionary *)dictionary;
+(NSMutableURLRequest *)getRequestWithAction:(NSString*)action;
+(NSString*)formatDateString:(NSString*)dateString;

//API ACTIONS
-(BOOL) needAuth;
-(void) getAuthTokenWithUsername:(NSString*)username andPassword:(NSString*)password;
-(void) gotAuthError:(NSString*)error;
-(void) gotAuthToken:(NSString*)token;

-(void) getMe;
-(void) getProfile:(NSString*)profileId;
-(void) getProfile:(NSString*)profileId withNotificationName:(NSString*)notifName;
-(void) setProfilePic:(NSString*)photoId;

-(void) getNotifications;

-(void) getFollows;
-(void) getFollowRequests;
-(void) setFollowRequestsUserId:(NSString*)userId action:(BOOL)action;

-(void) getFeed;
-(void) getFeedAfter:(NSString*)feedId;
-(void) getFeedCategory:(NSString*)category_id;
-(void) getFeedCategory:(NSString*)category_id after:(NSString*)last_timestamp;
-(void) getUserFeed:(NSString*)user_id;
-(void) getUserFeed:(NSString*)user_id after:(NSString*)feedId;

-(void) getCategories;

-(void) getCommentsFor:(NSString *)feedType andId:(NSString *)feedId;

-(void)postPost:(Post*)post;
-(void)postPhoto:(Photo*)photo;




@end
