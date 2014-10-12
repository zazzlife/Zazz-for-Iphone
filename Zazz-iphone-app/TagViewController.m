//
//  UIViewController_TagViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "TagViewController.h"

@implementation TagViewController

@synthesize titleLabel;
@synthesize tag;

-(void)viewWillAppear:(BOOL)animated{
    NSString* title = @"";
    switch (self.tag) {
    case 0:
        title = @"Tag people";
        break;
    case 1:
        title = @"Share with";
        break;
    case 2:
    default:
        title = @"Tag a place";
        break;
    }
    self.titleLabel.text = title;
}

- (IBAction)goBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
