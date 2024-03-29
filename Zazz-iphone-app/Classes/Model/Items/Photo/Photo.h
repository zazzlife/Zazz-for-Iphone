//
//  Photo.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Photo : NSObject

@property NSString* photoId;
@property NSString* albumId;
@property NSString* description;
@property User* user;
@property UIImage* image;
@property NSString* photoUrl;
@property NSMutableArray* categories;

+(Photo*)makePhotoFromDict:(NSDictionary*)photo_dict;

@end
