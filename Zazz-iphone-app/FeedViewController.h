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

@interface FeedViewController : UIViewController
    <UITableViewDataSource,UITableViewDelegate, CFTabBarViewDelegate>

@property NSMutableArray* feed;
@property NSArray* filteredFeed;

@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_left;
@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_right;

@property IBOutlet UITableView* feedTableView;
@property IBOutlet UIView * leftNav;
@property IBOutlet UIView * rightNav;

-(void)navigationDrawerAnimation;
-(NSMutableArray*)getFilteredFeed;

-(IBAction)leftDrawerButton:(id)sender;
-(IBAction)rightDrawerButton:(id)sender;
-(IBAction)expandFilterCell:(id)sender;
-(IBAction)toggleFilter:(id)sender;

@end
