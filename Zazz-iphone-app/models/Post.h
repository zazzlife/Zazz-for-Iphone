//
//  Post.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Post : NSObject

@property NSString* postId;
@property NSString* timestamp;
@property NSString* message;
@property User* fromUser;
@property User* toUser;
@property NSMutableArray* categories;

+(Post*)makePostFromDict:(NSDictionary*)post_dict;

@end
