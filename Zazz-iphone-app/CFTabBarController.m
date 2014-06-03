//
//  CFTabBarController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/3/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "CFTabBarController.h"

@implementation CFTabBarController

-(void) viewDidAppear:(BOOL)animated{
    [self.postButton setBackButtonBackgroundImage:[UIImage imageNamed:@"post button"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}
-(IBAction)didClickBarButton:(UIBarButtonItem*)sender{
    switch(sender.tag){
        case 2:
            NSLog(@"clicked post");
            [self.feedView setHidden:true];
            [self.profileView setHidden:true];
            [self.postView setHidden:false];
            break;
        case 3:
            NSLog(@"clicked profile");
            [self.feedView setHidden:true];
            [self.postView setHidden:true];
            [self.profileView setHidden:false];
            break;
        default:
            NSLog(@"clicked feed");
            [self.profileView setHidden:true];
            [self.postView setHidden:true];
            [self.feedView setHidden:false];
            break;
    }
}

@end
