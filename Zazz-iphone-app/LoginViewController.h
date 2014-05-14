//
//  LoginViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZazzApi.h"

@interface LoginViewController : UIViewController<ZazzLoginDelegate>

@property IBOutlet UITextField * _username;
@property IBOutlet UITextField * _password;

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView * loginprogress;


-(IBAction)doLogin:(id)sender;
-(IBAction)userHitReturn:(id)sender;
-(IBAction)userTappedBackgroud:(id)sender;

@end
