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

@interface LoginController : UIViewController<UITextFieldDelegate> {

@private
    __weak IBOutlet UIImageView *_loginImageView;
    __weak IBOutlet UITextField *_usernameTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIButton *_loginButton;
}


// View's key pressed event handlers
- (IBAction)keyPressed:(id)sender;

@end
