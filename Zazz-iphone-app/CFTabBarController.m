//
//  CFTabBarController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/3/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "AppDelegate.h"
#import "CFTabBarController.h"
#import "PostViewController.h"
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "UIColor.h"

@implementation CFTabBarController

FeedViewController*    feedView;
PostViewController*    postView;
ProfileViewController* profileView;

-(void)viewDidLoad{
    
    [[AppDelegate zazzApi] getMyProfile];
    [[AppDelegate getAppDelegate] setAppTabBar:self];
    
    //set child controllers.
    for(UIViewController* childController in self.childViewControllers){
        if([NSStringFromClass(childController.class) isEqualToString:@"PostViewController"]){
            postView = (PostViewController*)childController;
            continue;
        }
        if([NSStringFromClass(childController.class) isEqualToString:@"FeedViewController"]){
            feedView = (FeedViewController*)childController;
            continue;
        }
        if([NSStringFromClass(childController.class) isEqualToString:@"ProfileViewController"]){
            profileView = (ProfileViewController*)childController;
            continue;
        }
    }
}

-(void) viewDidAppear:(BOOL)animated{
    UIImage* tabImage = [UIImage imageNamed:@"post button"];
    [(UITabBarItem*)self.tabBarItem setFinishedSelectedImage:tabImage withFinishedUnselectedImage:tabImage];
    [self.postButton setImage:tabImage];
}
-(IBAction)didClickBarButton:(UIBarButtonItem*)sender{
    switch(sender.tag){
        case 2://post
            //[feedView setViewHidden:true];
            //[profileView setViewHidden:true];
            [postView setViewHidden:false];
            break;
        case 3://profile
            [feedView setViewHidden:true];
            [postView setViewHidden:true];
            [profileView setViewHidden:false];
            break;
        default://feed
            [profileView setViewHidden:true];
            [postView setViewHidden:true];
            [feedView setViewHidden:false];
            break;
    }
}

-(void)goHome{
    UIBarButtonItem* sender = [[UIBarButtonItem alloc]init];
    sender.tag = 0;
    [self didClickBarButton:sender];
}

@end
