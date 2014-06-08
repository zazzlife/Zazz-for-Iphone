//
//  LeftNavigationViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/26/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "ZazzApi.h"

@interface LeftNavigationViewController : UIViewController

@property IBOutlet UIImageView* profilePhoto;
@property Profile* _profile;

@end
