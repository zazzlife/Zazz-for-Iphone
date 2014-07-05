//
//  TextPostViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "TextPostViewController.h"
#import "AppDelegate.h"
#import "PostViewController.h"

@implementation TextPostViewController

- (IBAction)goBack:(UIButton *)sender {
    [(PostViewController*)self.parentViewController setViewHidden:true];
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    for(UIView* subview in self.view.subviews){
        if(subview.tag < 200)continue;
        subview.layer.cornerRadius = 5;
        subview.layer.masksToBounds = YES;
    }
}

@end
