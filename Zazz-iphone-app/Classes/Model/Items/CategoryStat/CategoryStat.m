//
//  Category.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "CategoryStat.h"
#import "UIImage.h"

@implementation CategoryStat

@synthesize category_id;
@synthesize name;
@synthesize userCount;

-(NSString*)getIconName{
    
    switch([self.category_id intValue]){
        case 1:{
            return @"Concert";
        }case 2:{
            return @"Drink_Special";
        }case 3:{
            return @"Hip_Hop_Music";
        }case 4:{
            return @"Turning_Up";
        }case 5:{
            return @"House_Party";
        }case 6:{
            return @"Ladies_Free";
        }case 7:{
            return @"Live_Music_Mic";
        }case 8:{
            return @"No_Cover";
        }case 9:{
            return @"Open_Bar";
        }case 10:{
            return @"Packed";
        }case 11:{
            return @"Pre_Drink";
        }case 12:{
            return @"House_Music";
        }default:{
            return nil;
        }
    }
}



+(CategoryStat*)makeCategoryFromDict:(NSDictionary*)cat_dict{
    CategoryStat* category = [[CategoryStat alloc] init];
    [category setCategory_id:[cat_dict objectForKey:@"id"]];
    [category setName:[cat_dict objectForKey:@"name"]];
    [category setUserCount:[[cat_dict objectForKey:@"usersCount"] intValue]];
    return category;
}


@end
