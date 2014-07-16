//
//  Category.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryStat : NSObject

@property NSString* category_id;
@property NSString* name;
@property int userCount;

-(UIImage*)getIcon;
+(CategoryStat*)makeCategoryFromDict:(NSDictionary*)cat_dict;
@end
