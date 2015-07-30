//  Project name: Zazz-iphone-app
//  File name   : UserTypeCell.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/30/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Hasan Serdar ÇINAR. All rights reserved.
//  --------------------------------------------------------------

#import <UIKit/UIKit.h>


@interface UserTypeCell : UITableViewCell {
    
@private
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UIImageView *_lineImageView;
}

@property (nonatomic, readonly) UILabel *titleLabel;

@end
