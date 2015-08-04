//
//  RegisterViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface RegisterController : UIViewController<FBLoginViewDelegate> {
    
@private
    __weak IBOutlet FBLoginView *_facebookView;
    __weak IBOutlet UIButton *_registerButton;
}


// View's key pressed event handlers
- (IBAction)keyPressed:(id)sender;

@end
