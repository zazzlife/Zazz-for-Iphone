//
//  City.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/24/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "GenericModel.h"

@implementation GenericModel

@synthesize _id;
@synthesize name;


+(GenericModel*)makeGenericModelFromDict:(NSDictionary*)dict{
    GenericModel* genModel = [[GenericModel alloc] init];
    [genModel set_id:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
    [genModel setName:[dict objectForKey:@"name"]];
    return genModel;
}

@end
