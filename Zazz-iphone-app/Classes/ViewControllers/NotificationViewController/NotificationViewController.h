//
//  NotificationViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface NotificationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property User* user;
@property UITableViewController* tableViewController;

@property IBOutlet UISegmentedControl* segmentedControl;

-(IBAction)changeView:(UISegmentedControl*)sender;
-(IBAction)goBack:(UIButton*)backButton;
-(void)showNextView:(UIButton*)notificationIcon;

@end
