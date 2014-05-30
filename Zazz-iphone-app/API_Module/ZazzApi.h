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

@protocol ZazzLoginDelegate<NSObject>
-(void)finishedZazzAuth:(BOOL)success;
@end

@protocol ZazzProfileDelegate <NSObject>
-(void)gotZazzProfile:(Profile*)profile;
@end

@protocol ZazzFeedDelegate <NSObject>
-(void)gotZazzFeed:(NSMutableArray*)feed;
@end

@protocol ZazzCategoryDelegate <NSObject>
-(void)gotZazzCategories:(NSMutableArray*)categories;
@end


@interface ZazzApi: NSObject

@property NSString* auth_token;

+(NSString *) BASE_URL;
+(NSString *) urlEscapeString:(NSString *)unencodedString;
+(NSString *) getQueryStringFromDictionary:(NSDictionary *)dictionary;

-(BOOL) needAuth;
-(void) getAuthTokenWithUsername:(NSString*)username andPassword:(NSString*)password delegate:(id)delegate;
-(void) gotLoginToken:(NSString*)token;

-(void) getMyProfileDelegate:(id)delegate;
-(void) getProfile:(NSString*)userId delegate:(id)delegate;
-(void) gotProfile:(Profile*)profile;

-(void) getMyFeedDelegate:(id)delegate;
-(void) getMyFeedAfter:(NSString*)last_timestamp delegate:(id)delegate;
-(void) gotFeed:(NSMutableArray*)feed;

-(void) getCategories:(id)delegate;
-(void) gotCategories:(NSMutableArray*)categories;

@end
