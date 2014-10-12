//
//  UIViewController_TagViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagViewController:UIViewController

@property int tag;
@property IBOutlet UILabel* titleLabel;

- (IBAction)goBack:(UIButton *)sender;

@end
