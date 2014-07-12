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

const int TAG_FEED_VIEW = 0;
const int TAG_POST_VIEW = 1;
const int TAG_PROFILE_VIEW = 2;
int activeTagView;


CGRect FRAME_FULL;
CGRect FRAME_TABBED;

FeedViewController*    feedView;
PostViewController*    postView;
ProfileViewController* profileView;
BOOL enabled = true;

-(void)viewDidLoad{
    
    FRAME_FULL = [UIApplication sharedApplication].keyWindow.frame;
    FRAME_TABBED = CGRectMake(0, 0, FRAME_FULL.size.width, FRAME_FULL.size.height - self.tabBar.frame.size.height);
    
    [[AppDelegate zazzApi] getMyProfile];
    [[AppDelegate getAppDelegate] setAppTabBar:self];
    [self.tabBar setBackgroundColor:[UIColor colorFromHexString:APPLICATION_BLACK]];
    
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

-(UIView*)getActiveChildView{
    UIView* activeView;
    switch(activeTagView){
        case TAG_POST_VIEW:
            activeView = postView.view;
        case TAG_PROFILE_VIEW:
            activeView = profileView.view;
        case TAG_FEED_VIEW:
        default:
            activeView = feedView.view;
    }
    return activeView;
}

-(void)enable{
    enabled = true;
    [self.tabBar setHidden:false];
    UIView* activeViewTest = self.getActiveChildView;
    [activeViewTest setFrame:CGRectMake(
                                        activeViewTest.frame.origin.x ,
                                        activeViewTest.frame.origin.y,
                                        activeViewTest.frame.size.width,
                                        self.view.frame.size.height - self.tabBar.frame.size.height
                                        )
     ];
    for(UIView* view in activeViewTest.subviews){
        [view setFrame:CGRectMake(
                                  view.frame.origin.x ,
                                  view.frame.origin.y,
                                  view.frame.size.width,
                                  self.view.frame.size.height - self.tabBar.frame.size.height
                                  )
         ];
    }
}
-(void)disable{
    enabled = false;
    [self.tabBar setHidden:true];
    UIView* activeViewTest = self.getActiveChildView;
    [activeViewTest setFrame:self.view.frame];
    for(UIView* views in activeViewTest.subviews){
        [views setFrame:CGRectMake(
                                   views.frame.origin.x ,
                                   views.frame.origin.y,
                                   views.frame.size.width,
                                   self.view.frame.size.height
                                   )
         ];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    UIImage* tabImage = [UIImage imageNamed:@"post button"];
    [(UITabBarItem*)self.tabBarItem setFinishedSelectedImage:tabImage withFinishedUnselectedImage:tabImage];
    [self.postButton setImage:tabImage];
}
-(IBAction)didClickBarButton:(UIBarButtonItem*)sender{
    if (! enabled) return;
    switch(sender.tag){
        case 2://post
            //[feedView setViewHidden:true];
            //[profileView setViewHidden:true];
            [postView setViewHidden:false];
            activeTagView = TAG_POST_VIEW;
            break;
        case 3://profile
            [feedView setViewHidden:true];
            [postView setViewHidden:true];
            [profileView setViewHidden:false];
            activeTagView = TAG_PROFILE_VIEW;
            break;
        case 1://feed
        default:
            [profileView setViewHidden:true];
            [postView setViewHidden:true];
            [feedView setViewHidden:false];
            activeTagView=TAG_POST_VIEW;
            break;
    }
}

-(void)goHome{
    UIBarButtonItem* sender = [[UIBarButtonItem alloc]init];
    sender.tag = 0;
    [self didClickBarButton:sender];
}

@end
