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

#define LEFT_NAV_PROFILE_PHOTO_HEIGHT 140


@interface LeftNavigationViewController : UIViewController

@property IBOutlet UIImageView* profilePhoto;
@property IBOutlet UIImageView* background;
@property User* _user;
@property IBOutlet UIScrollView* scrollView;

-(IBAction) showNextView:(UIButton*)button;

@end
