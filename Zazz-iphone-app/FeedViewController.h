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

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, CFTabBarViewDelegate>

@property NSString* active_category_id;
@property NSMutableArray* feed;
@property NSMutableDictionary* categoryFeeds;
@property NSArray* filteredFeed;
@property UIViewController* activeNextView;

@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_left;
@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_right;

@property IBOutlet UITableView* feedTableView;
@property IBOutlet UIView * navFeedView;
@property IBOutlet UIView * leftNav;
@property IBOutlet UIView * rightNav;
@property IBOutlet UIView * nextView;

-(IBAction)leftDrawerButton:(id)sender;
-(IBAction)rightDrawerButton:(id)sender;

//Filter related
-(NSMutableArray*)getFilteredFeed;
-(IBAction)expandFilterCell:(id)sender;
-(IBAction)toggleFilter:(id)sender;
-(void)getFeedAfter:(NSString*)feed_id;
-(BOOL)setActiveCategory:(NSString*)active_category_id;

//LeftDrawer SubViews
-(void)prepareForNextViewWithIdentifier:(NSString*)identifier;
-(void)animateBackToFeedView;

@end


@protocol FeedViewControllerChild <NSObject>
@required
-(void)setParentViewController:(FeedViewController*)controller;

@end
