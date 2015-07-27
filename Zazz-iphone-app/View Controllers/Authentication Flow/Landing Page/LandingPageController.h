//  Project name: Zazz-iphone-app
//  File name   : LandingPageController.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/27/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Hasan Serdar ÇINAR. All rights reserved.
//  --------------------------------------------------------------

#import <UIKit/UIKit.h>


@interface LandingPageController : UIViewController {

@private
    __weak IBOutlet UIButton *_registerButton;
    __weak IBOutlet UIButton *_signinButton;
}


// View's key pressed event handlers
- (IBAction)keyPressed:(id)sender;

@end
