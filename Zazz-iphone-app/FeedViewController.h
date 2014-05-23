//
//  FeedTableViewController.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZazzApi.h"

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZazzFeedDelegate> {
    
    UIView *navigationDrawerLeft;
}
@property NSMutableArray* feed;

@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_left;
@property (readonly, nonatomic) UISwipeGestureRecognizer *swipe_right;

@property IBOutlet UITableView* feedTableView;
@property IBOutlet UIView * sideNav;

-(void)navigationDrawerAnimation;

-(IBAction)leftDrawerButton:(id)sender;
-(IBAction)expandFilterCell:(id)sender;

@end
