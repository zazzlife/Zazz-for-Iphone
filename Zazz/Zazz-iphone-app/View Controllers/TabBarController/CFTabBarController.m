//
//  CFTabBarController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/3/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

//#import "AppDelegate.h"
//#import "CFTabBarController.h"
//#import "PostViewController.h"
//#import "HomeViewController.h"
//#import "ProfileViewController.h"
//#import "UIColor.h"

/*
@interface CFTabBarController() <PostViewControllerDelegate> {}
@end

@implementation CFTabBarController

const int TAG_FEED_VIEW = 1;
const int TAG_POST_VIEW = 2;
const int TAG_PROFILE_VIEW = 3;
int _activeTagView = 1;

CGRect FRAME_FULL;
CGRect FRAME_TABBED;

HomeViewController*    homeView;
PostViewController*    postView;
ProfileViewController* profileView;
BOOL enabled = true;

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    FRAME_FULL = [UIApplication sharedApplication].keyWindow.frame;
    FRAME_TABBED = CGRectMake(0, 0, FRAME_FULL.size.width, FRAME_FULL.size.height - self.tabBar.frame.size.height);
    
    [[AppDelegate zazzApi] getMe];
    [[AppDelegate getAppDelegate] setAppTabBar:self];
    [self.tabBar setBackgroundColor:[UIColor colorFromHexString:COLOR_ZAZZ_BLACK]];
    
    //set child controllers.
    for(UIViewController* childController in self.childViewControllers){
        if([NSStringFromClass(childController.class) isEqualToString:@"PostViewController"]){
            postView = (PostViewController*)childController;
            continue;
        }
        if([NSStringFromClass(childController.class) isEqualToString:@"HomeViewController"]){
            homeView = (HomeViewController*)childController;
            continue;
        }
        if([NSStringFromClass(childController.class) isEqualToString:@"UINavigationController"]){
            profileView = (ProfileViewController*)[(UINavigationController *)childController topViewController];
            continue;
        }
    }
    [self.tabBar setHidden:false];
    CGRect tabBarFrame = self.tabBar.frame;
    [AppDelegate removeZazzBackgroundLogo];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![kPreferences accessToken]) {
        [self performSegueWithIdentifier:kSegue_PresentAuthenticationFlow sender:nil];
    }
    else {
        UIImage* tabImage = [UIImage imageNamed:@"post button"];
        [(UITabBarItem*)self.tabBarItem setFinishedSelectedImage:tabImage withFinishedUnselectedImage:tabImage];
        [self.postButton setImage:tabImage];
        UIBarButtonItem* simButton = [[UIBarButtonItem alloc] init];
        [simButton setTag:_activeTagView];
        [self didClickBarButton:simButton];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[PostViewController class]]) {
        __weak PostViewController *controller = (PostViewController *) segue.destinationViewController;
        controller.delegate = self;
    }
}


-(IBAction)didClickBarButton:(UIBarButtonItem*)sender{
    
    if (! enabled) return;
    
    switch(sender.tag){
        case 2: { //post
            [postView setViewHidden:false];
            _activeTagView = TAG_POST_VIEW;
            break;
        }
        case 3: { //profile
            //            [homeView setViewHidden:true];
            //            [postView setViewHidden:true];
            //            [profileView setViewHidden:false];
            //            _activeTagView = TAG_PROFILE_VIEW;
            
//            [profileView setViewHidden:NO];
//            _activeTagView = TAG_PROFILE_VIEW;
            
//            profileView.view.hidden = NO;
//            profileView.view.alpha = 0.0f;
//            _activeTagView = TAG_PROFILE_VIEW;
            [profileView setViewHidden:NO];
            [UIView animateWithDuration:0.1f
                             animations:^{
                                 postView.view.alpha = 0.0f;
                                 profileView.view.alpha = 1.0f;
                                 homeView.view.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 postView.view.hidden = YES;
                                 homeView.view.hidden = YES;
                                 profileView.view.hidden = NO;
                                 _activeTagView = TAG_PROFILE_VIEW;
                             }];
            break;
        }
        case 1: { //feed
//            homeView.view.hidden = NO;
//            homeView.view.alpha = 0.0f;
            
            [homeView setViewHidden:NO];
             _activeTagView = TAG_FEED_VIEW;
            
            [UIView animateWithDuration:0.1f
                             animations:^{
                                 postView.view.alpha = 0.0f;
                                 profileView.view.alpha = 0.0f;
                                 homeView.view.alpha = 1.0f;
                                 
                             }
                             completion:^(BOOL finished) {
                                 postView.view.hidden = YES;
                                 profileView.view.hidden = YES;
                                 homeView.view.alpha = 1.0f;
                                 homeView.view.hidden = NO;
                                 homeView.view.backgroundColor = [UIColor redColor];
                                 _activeTagView = TAG_FEED_VIEW;
                                 
                             }];
            break;
        }
        default: {
            //            [postView setViewHidden:true];
            //            [profileView setViewHidden:true];
            //            [homeView setViewHidden:false];
            //            _activeTagView = TAG_FEED_VIEW;
            
            homeView.view.hidden = NO;
            homeView.view.alpha = 0.0f;
            
            [UIView animateWithDuration:0.1f
                             animations:^{
                                 postView.view.alpha = 0.0f;
                                 profileView.view.alpha = 0.0f;
                                 homeView.view.alpha = 1.0f;
                             }
                             completion:^(BOOL finished) {
                                 postView.view.hidden = YES;
                                 profileView.view.hidden = YES;
                                 
                                 _activeTagView = TAG_FEED_VIEW;
                             }];
            break;
        }
    }
}

#pragma mark - PostViewControllerDelegate's members
- (void)postViewControllerDidRequestToPresentPost:(PostViewController *)controller {
    [self performSegueWithIdentifier:kSegue_PresentShareView sender:nil];
}

@end
 */
