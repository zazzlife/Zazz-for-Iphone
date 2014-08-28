//
//  UserDetails.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/27/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericModel.h"

@interface UserDetails : NSObject

@property NSString* fullName;
@property NSString* gender;
@property GenericModel* city;
@property GenericModel* major;
@property GenericModel* school;

+(UserDetails*)makeUserDetailsFromDict:(NSDictionary*)details_dict;


@end
