//  Project name: Zazz-iphone-app
//  File name   : ExtraInfoController.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/28/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Hasan Serdar ÇINAR. All rights reserved.
//  --------------------------------------------------------------

#import <UIKit/UIKit.h>


@interface ExtraInfoController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {

@private
    __weak IBOutlet UIButton *_ageButton;
    __weak IBOutlet UIButton *_maleButton;
    __weak IBOutlet UIButton *_femaleButton;
    __weak IBOutlet UIButton *_resignButton;
    __weak IBOutlet UIButton *_finishButton;
    
    __weak IBOutlet UILabel *_genderLabel;
    __weak IBOutlet UIImageView *_maleImageView;
    __weak IBOutlet UIImageView *_femaleImageView;
    
    IBOutlet UIPickerView *_agePickerView;
}

@property (nonatomic, weak) id<FBGraphUser> user;
@property (nonatomic, weak) NSMutableDictionary *info;


// View's key pressed event handlers
- (IBAction)keyPressed:(id)sender;

@end
