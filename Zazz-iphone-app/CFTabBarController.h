//
//  CFTabBarController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/3/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFTabBarController : UIViewController

@property IBOutlet UIView* feedView;
@property IBOutlet UIView* postView;
@property IBOutlet UIView* profileView;

@property IBOutlet UIBarButtonItem* feedButton;
@property IBOutlet UIBarButtonItem* postButton;
@property IBOutlet UIBarButtonItem* profileButton;

@property int activeView;

-(IBAction)didClickBarButton:(UIBarButtonItem*)sender;

@end
