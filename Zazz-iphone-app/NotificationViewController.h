//
//  NotificationViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@interface NotificationViewController : UIViewController<FeedViewControllerChild>

-(IBAction)goBack:(UIButton*)backButton;

@end
