//
//  UIViewController_TagViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagViewController:UIViewController<UITableViewDataSource>

@property int tag;
@property NSMutableArray* dataSource;

@property IBOutlet UITextField* searchFeild;
@property IBOutlet UIImageView* searchImage;
@property IBOutlet UILabel* titleLabel;

- (IBAction)goBack:(UIButton *)sender;

@end
