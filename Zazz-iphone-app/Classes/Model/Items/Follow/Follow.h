//
//  Follow.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/13/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface Follow : NSObject

@property NSString* userId;
@property NSString* displayName;
@property Photo* displayPhoto;

+(Follow*)makeFollowFromDict:(NSMutableDictionary*)follow_dict;

@end
