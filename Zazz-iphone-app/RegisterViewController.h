//
//  RegisterViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController


@property IBOutlet UITextField* firstName;
@property IBOutlet UITextField* lastName;
@property IBOutlet UITextField* email;
@property IBOutlet UITextField* username;
@property IBOutlet UIPickerView* type;
@property IBOutlet UITextField* password;

-(IBAction)doRegistration:(id)sender;
-(IBAction)userTappedBackgroud:(id)sender;
-(IBAction)userHitReturn:(id)sender;

@end
