//
//  ProfileViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableViewController.h"
#import "CFTabBarController.h"
#import "Profile.h"
#import "MediaFeedController.h"
#import "PhotoPicker.h"
#import "RSKImageCropViewController.h"

#define PROFILE_PAGE_PHOTO_HEIGHT 140

@interface ProfileViewController : UIViewController <CFTabBarViewDelegate, StickyTopScrollViewDelegate, MediaReceiver,RSKImageCropViewControllerDelegate> {

@private
    __weak IBOutlet FwiImage *_profileView;
    __weak IBOutlet UISegmentedControl *_segmentView;
}

@property FeedTableViewController* feedTableViewController;
@property MediaFeedController* mediaFeedViewController;

@property NSString* user_id;
@property Profile* _profile;
@property IBOutlet UIScrollView* scrollView;

@property IBOutlet UIButton* changeImageButton;
@property IBOutlet UIButton* leftBarButton;
@property IBOutlet UIButton* rightBarButton;
@property IBOutlet UIImageView* profilePhoto;
@property IBOutlet UILabel* username;
@property IBOutlet UILabel* name;
@property IBOutlet UILabel* school;
@property IBOutlet UILabel* city;
@property IBOutlet UILabel* tagline;
@property IBOutlet UILabel* likes;
@property IBOutlet UILabel* following;
@property IBOutlet UILabel* followers;
@property IBOutlet UIButton* follow;
@property IBOutlet UISegmentedControl* filterButtons;
@property IBOutlet UIView* postFeedView;
@property IBOutlet UIView* mediaFeedView;
@property IBOutlet UIView* topContainer;

-(IBAction)changeFeed:(UISegmentedControl*)sender;
-(IBAction)changeProfileImage:(UIButton*)sender;

-(void)enableBackButton;
-(void)setProfile:(Profile*)profile;

- (IBAction)segmentChanged:(id)sender;

@end
