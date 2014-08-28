//
//  Profile.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User: NSObject

@property NSString* userId;
@property BOOL is_public;
@property NSString* accountType;
@property BOOL isConfirmed;
@property NSString* username;
@property UIImage* image;
@property NSString* photoUrl;

+(User*)makeUserFormDict:(NSDictionary*)user_dict;

@end
