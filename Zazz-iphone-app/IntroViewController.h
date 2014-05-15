//
//  IntroViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroViewController : UIViewController

@property IBOutlet UIButton * loginButton;
@property IBOutlet UIButton * registerButton;

-(IBAction)showLogin:(id)sender;
-(IBAction)showRegister:(id)sender;


@end
