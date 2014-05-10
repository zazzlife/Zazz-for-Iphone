//
//  ZAZZCaller.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/8/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZazzApiClass;

@interface ZazzApi: NSObject

@property NSString* auth_token;

+(NSString *) BASE_URL;
+(NSString *) urlEscapeString:(NSString *)unencodedString;
+(NSString *) getQueryStringFromDictionary:(NSDictionary *)dictionary;

-(BOOL)needAuth;
-(void) doLoginWithUsername:(NSString*)username andPassword:(NSString*)password;
-(void) gotLoginToken:(NSString*)token;

-(void) getMe;
-(void) gotUserId:(NSString*)userId;

@end
