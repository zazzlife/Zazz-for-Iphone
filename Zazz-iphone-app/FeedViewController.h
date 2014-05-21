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

@property (readonly, nonatomic) UISwipeGestureRecognizer *recognizer_open_drawer;
@property (readonly, nonatomic) UISwipeGestureRecognizer *recognizer_close_drawer;

@property (readonly, nonatomic) int navigationDrawerLeftX, navigationDrawerLeftWidth;

@property (nonatomic, strong) NSArray *Usernames;
@property (nonatomic, strong) NSArray *TimeStamps;
@property (nonatomic, strong) NSArray *UserImages;
@property IBOutlet UIActivityIndicatorView * loginprogress;
@property IBOutlet UITableView* feedTableView;
@property IBOutlet UIView * sideNav;

-(void)doSwipes:(UIGestureRecognizer *) sender;

-(void)navigationDrawerAnimation;

-(IBAction)leftDrawerButton:(id)sender;

@end
