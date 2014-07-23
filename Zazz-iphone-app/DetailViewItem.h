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

@property NSString* itemId;
@property NSString* type;
@property NSString* description;
@property UIImage* photo;
@property Profile* user;
@property int likes;
@property NSMutableArray* comments;;

@end
