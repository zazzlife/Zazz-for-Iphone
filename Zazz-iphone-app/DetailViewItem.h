//
//  DetailViewItem.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/15/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface DetailViewItem : NSObject

extern const int TYPE_POST;
extern const int TYPE_PHOTO;
extern const int TYPE_EVENT;

@property int type;
@property int itemId;
@property UIImage* photo;
@property NSString* description;
@property Profile* user;
@property int likes;
@property NSMutableArray* comments;

-(NSString*)typeToString;

@end
