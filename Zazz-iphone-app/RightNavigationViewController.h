//
//  RightNavigationViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/26/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZazzApi.h"

@interface RightNavigationViewController : UIViewController<ZazzCategoryDelegate>

@property NSMutableArray* categories;

@end
