//  Project name: Zazz-iphone-app
//  File name   : UserTypeController.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/28/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Hasan Serdar ÇINAR. All rights reserved.
//  --------------------------------------------------------------

#import <UIKit/UIKit.h>


@interface UserTypeController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

@private
    __weak IBOutlet UIButton *_taglineButton;
    __weak IBOutlet UIButton *_promoterButton;
    __weak IBOutlet UIButton *_doneButton;
    
    __weak IBOutlet UITableView *_tableView;
}


// View's key pressed event handlers
- (IBAction)keyPressed:(id)sender;

@end
