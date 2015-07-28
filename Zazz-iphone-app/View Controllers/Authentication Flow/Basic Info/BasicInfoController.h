//  Project name: Zazz-iphone-app
//  File name   : BasicInfoController.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/28/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Hasan Serdar ÇINAR. All rights reserved.
//  --------------------------------------------------------------

#import <UIKit/UIKit.h>


@interface BasicInfoController : UIViewController <UITextFieldDelegate> {

@private
    __weak IBOutlet UITextField *_usernameTextField;
    __weak IBOutlet UITextField *_emailTextField;
    __weak IBOutlet UITextField *_confirmTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    
    __weak IBOutlet UIButton *_nextButton;
}

@property (nonatomic, strong) id<FBGraphUser> user;


// View's key pressed event handlers
- (IBAction)keyPressed:(id)sender;

@end
