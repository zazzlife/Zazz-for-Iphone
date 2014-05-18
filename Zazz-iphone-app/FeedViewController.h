//
//  FeedTableViewController.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    UIView *navigationDrawerLeft;
}

@property (readonly, nonatomic) UISwipeGestureRecognizer *recognizer_open_drawer;
@property (readonly, nonatomic) UISwipeGestureRecognizer *recognizer_close_drawer;

@property (readonly, nonatomic) int navigationDrawerLeftX, navigationDrawerLeftWidth;

@property (nonatomic, strong) NSArray *Usernames;
@property (nonatomic, strong) NSArray *TimeStamps;
@property (nonatomic, strong) NSArray *UserImages;

-(void)doSwipes:(UIGestureRecognizer *) sender;

-(void)navigationDrawerAnimation;

-(IBAction)leftDrawerButton:(id)sender;

@end
