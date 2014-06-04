//
//  CFTabBarController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/3/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "CFTabBarController.h"
#import "PostViewController.h"
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "UIColor.h"

@implementation CFTabBarController

-(void) viewDidAppear:(BOOL)animated{
    [self.postButton setImage:[UIImage imageNamed:@"post button"]];
}
-(IBAction)didClickBarButton:(UIBarButtonItem*)sender{
    
    //get indexes of eacho subViewController
    NSArray* childControllers = self.childViewControllers;
    int feedIdx, postIdx, profileIdx = -1;
    int cIndex = 0;
    for(UIViewController* childController  in childControllers){
        if([NSStringFromClass(childController.class) isEqualToString:@"PostViewController"]){
            postIdx = cIndex;
        }
        else if([NSStringFromClass(childController.class) isEqualToString:@"FeedViewController"]){
            feedIdx = cIndex;
        }
        else if([NSStringFromClass(childController.class) isEqualToString:@"ProfileViewController"]){
            profileIdx = cIndex;
        }
        cIndex++;
    }
    
    switch(sender.tag){
        case 2:
            //post
//            [self.feedView setHidden:true];
            [(FeedViewController*)[childControllers objectAtIndex:feedIdx] toggleViewHidden:true];
//            [self.profileView setHidden:true];
            [(ProfileViewController*)[childControllers objectAtIndex:profileIdx] toggleViewHidden:true];
//            [self.postView setHidden:false];
            [(PostViewController*)[childControllers objectAtIndex:postIdx] toggleViewHidden:false];
            break;
        case 3:
            //profile
//            [self.feedView setHidden:true];
            [(FeedViewController*)[childControllers objectAtIndex:feedIdx] toggleViewHidden:true];
//            [self.postView setHidden:true];
            [(PostViewController*)[childControllers objectAtIndex:postIdx] toggleViewHidden:true];
//            [self.profileView setHidden:false];
            [(ProfileViewController*)[childControllers objectAtIndex:profileIdx] toggleViewHidden:false];
            break;
        default:
            //feed
//            [self.profileView setHidden:true];
            [(ProfileViewController*)[childControllers objectAtIndex:profileIdx] toggleViewHidden:true];
//            [self.postView setHidden:true];
            [(PostViewController*)[childControllers objectAtIndex:postIdx] toggleViewHidden:true];
//            [self.feedView setHidden:false];
            [(FeedViewController*)[childControllers objectAtIndex:feedIdx] toggleViewHidden:false];
            break;
    }
}

@end
