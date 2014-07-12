//
//  ProfileViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFTabBarController.h"
#import "Profile.h"

#define PROFILE_PAGE_PHOTO_HEIGHT 140

@interface ProfileViewController : UIViewController <CFTabBarViewDelegate>

@property Profile* _profile;
@property IBOutlet UIImageView* profilePhoto;

@end
