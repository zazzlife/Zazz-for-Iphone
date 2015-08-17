//
//  City.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenericModel : NSObject

@property (nonatomic, copy) NSString* _id;
@property (nonatomic, copy) NSString* name;

+(GenericModel*)makeGenericModelFromDict:(NSDictionary*)name_dict;

@end