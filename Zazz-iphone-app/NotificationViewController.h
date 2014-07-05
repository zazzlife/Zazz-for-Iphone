//
//  NotificationViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "Profile.h"

@interface NotificationViewController : UIViewController<ChildViewController, UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UISegmentedControl* segmentedControl;

@property UITableViewController* tableViewController;

-(IBAction)changeView:(UISegmentedControl*)sender;
-(IBAction)goBack:(UIButton*)backButton;

-(void)set_profile:(Profile*)profile;

@end
