//
//  DetailViewItem.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/15/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface DetailViewItem : NSObject

@property NSString* itemId;
@property NSString* type;
@property NSString* description;
@property UIImage* photo;
@property User* user;
@property int likes;
@property NSMutableArray* categories;
@property NSMutableArray* comments;

@end
