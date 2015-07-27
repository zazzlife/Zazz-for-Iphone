//
//  LoginViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZazzApi.h"
#import "AppDelegate.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property IBOutlet UITextField * _username;
@property IBOutlet UITextField * _password;
@property IBOutlet UIButton * backBtn;

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView * loginprogress;


-(IBAction)doLogin:(id)sender;
-(IBAction)goBack:(id)sender;

@end
