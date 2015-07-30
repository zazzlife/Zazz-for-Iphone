//  Project name: Zazz-iphone-app
//  File name   : BaseFormController.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/30/15
//  Version     : 1.01
//  --------------------------------------------------------------
//  Copyright (c) 2015 Hasan Serdar ÇINAR. All rights reserved.
//  --------------------------------------------------------------

#import <UIKit/UIKit.h>


@interface BaseFormController : UIViewController <UITextFieldDelegate> {
    
@protected
    BOOL _shouldHandleKeyboardNotificaiton;
}


- (void)updateMovableViewForView:(UIView *)view;

@end
