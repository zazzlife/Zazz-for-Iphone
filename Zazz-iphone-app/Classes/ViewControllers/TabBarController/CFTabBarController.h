//
//  CFTabBarController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/3/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

@protocol CFTabBarViewDelegate <NSObject>
-(void)setViewHidden:(BOOL)hidden;
@end


#import <Foundation/Foundation.h>

@interface CFTabBarController : UIViewController

@property IBOutlet UIToolbar* tabBar;
@property IBOutlet UIBarButtonItem* feedButton;
@property IBOutlet UIBarButtonItem* postButton;
@property IBOutlet UIBarButtonItem* profileButton;

@property int activeView;

-(IBAction)didClickBarButton:(UIBarButtonItem*)sender;

-(void)goHome;

@end
