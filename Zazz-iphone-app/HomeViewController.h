//
//  FeedTableViewController.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZazzApi.h"
#import "CFTabBarController.h"
#import "FeedTableViewController.h"

@interface HomeViewController : UIViewController<CFTabBarViewDelegate, ScrollViewDelegate>

@property FeedTableViewController* feedTableViewController;

@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_left;
@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_right;

@property IBOutlet UIView * leftNav;
@property IBOutlet UIView * rightNav;
@property IBOutlet UIView* navBar;
@property IBOutlet UIView* filterView;
@property IBOutlet UIView* feedTableViewContainer;
@property IBOutlet UIScrollView* centerScrollView;

-(IBAction)leftDrawerButton:(id)sender;
-(IBAction)rightDrawerButton:(id)sender;

//Filter related
-(IBAction)expandFilterCell:(id)sender;
-(IBAction)toggleFilter:(id)sender;
-(BOOL)setActiveCategory:(NSString*)active_category_id;

@end