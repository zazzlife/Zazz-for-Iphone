//
//  UIViewController_TagViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "TagViewController.h"

@implementation TagViewController

- (IBAction)goBack:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:true];
}

@end