//
//  NotificationViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "NotificationViewController.h"
#import "FeedViewController.h"

@implementation NotificationViewController

FeedViewController* feedViewController;

-(void)setParentViewController:(FeedViewController*)controller{
    feedViewController = controller;
}

-(IBAction)goBack:(UIButton*)backButton{
    [feedViewController animateBackToFeedView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
