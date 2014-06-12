//
//  Category.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "CategoryStat.h"

@implementation CategoryStat

@synthesize category_id;
@synthesize name;
@synthesize userCount;

-(UIImage*)getIcon{
    int catId = [self.category_id intValue];
    switch(catId){
        case 1:
            return [UIImage imageNamed:@"Concert_soundWave-white"];
        case 2:
            return [UIImage imageNamed:@"Drink_Special-white"];
        case 3:
            return [UIImage imageNamed:@"Hip_Hop_Music-white"];
        case 4:
            return [UIImage imageNamed:@"Turning_Up-white"];
        case 5:
            return [UIImage imageNamed:@"House_Party-white"];
        case 6:
            return [UIImage imageNamed:@"Ladies_Free-white"];
        case 7:
            return [UIImage imageNamed:@"Live_Music_Mic-white"];
        case 8:
            return [UIImage imageNamed:@"No_Cover-white"];
        case 9:
            return [UIImage imageNamed:@"Open_Bar-white"];
        case 10:
            return [UIImage imageNamed:@"Packed-white"];
        case 11:
            return [UIImage imageNamed:@"Pre_Drink-white"];
        case 12:
            return [UIImage imageNamed:@"House_Music-white"];
        default:
            return nil;
    }
}

@end
