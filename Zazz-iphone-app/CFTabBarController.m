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
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "UIColor.h"

@implementation CFTabBarController

const int TAG_FEED_VIEW = 0;
const int TAG_POST_VIEW = 1;
const int TAG_PROFILE_VIEW = 2;
int _activeTagView = 0;


CGRect FRAME_FULL;
CGRect FRAME_TABBED;

HomeViewController*    homeView;
PostViewController*    postView;
ProfileViewController* profileView;
BOOL enabled = true;

-(void)viewDidLoad{
    FRAME_FULL = [UIApplication sharedApplication].keyWindow.frame;
    FRAME_TABBED = CGRectMake(0, 0, FRAME_FULL.size.width, FRAME_FULL.size.height - self.tabBar.frame.size.height);
    
    [[AppDelegate zazzApi] getMyProfile];
    [[AppDelegate getAppDelegate] setAppTabBar:self];
    [self.tabBar setBackgroundColor:[UIColor colorFromHexString:COLOR_ZAZZ_BLACK]];
    
    //set child controllers.
    for(UIViewController* childController in self.childViewControllers){
        if([NSStringFromClass(childController.class) isEqualToString:@"PostViewController"]){
            postView = (PostViewController*)childController;
            continue;
        }
        if([NSStringFromClass(childController.class) isEqualToString:@"FeedViewController"]){
            homeView = (HomeViewController*)childController;
            continue;
        }
        if([NSStringFromClass(childController.class) isEqualToString:@"ProfileViewController"]){
            profileView = (ProfileViewController*)childController;
            continue;
        }
    }
    [self.tabBar setHidden:false];
    CGRect tabBarFrame = self.tabBar.frame;
    [AppDelegate removeZazzBackgroundLogo];
}

-(void) viewDidAppear:(BOOL)animated{
    UIImage* tabImage = [UIImage imageNamed:@"post button"];
    [(UITabBarItem*)self.tabBarItem setFinishedSelectedImage:tabImage withFinishedUnselectedImage:tabImage];
    [self.postButton setImage:tabImage];
    [postView setViewHidden:true];
}

-(UIView*)getActiveChildView{
    UIView* activeView;
    switch(_activeTagView){
        case TAG_POST_VIEW:
            activeView = postView.view;
        case TAG_PROFILE_VIEW:
            activeView = profileView.view;
        case TAG_FEED_VIEW:
        default:
            activeView = homeView.view;
    }
    return activeView;
}

-(IBAction)didClickBarButton:(UIBarButtonItem*)sender{
    if (! enabled) return;
    switch(sender.tag){
        case 2://post
            //[feedView setViewHidden:true];
            //[profileView setViewHidden:true];
            [postView setViewHidden:false];
            _activeTagView = TAG_POST_VIEW;
            break;
        case 3://profile
            [homeView setViewHidden:true];
            [postView setViewHidden:true];
            [profileView setViewHidden:false];
            _activeTagView = TAG_PROFILE_VIEW;
            break;
        case 1://feed
        default:
            [profileView setViewHidden:true];
            [postView setViewHidden:true];
            [homeView setViewHidden:false];
            _activeTagView=TAG_POST_VIEW;
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

-(void)goHome{
    UIBarButtonItem* sender = [[UIBarButtonItem alloc]init];
    sender.tag = 0;
    [self didClickBarButton:sender];
}

@end
