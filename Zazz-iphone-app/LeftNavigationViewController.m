//
//  LeftNavigationViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/26/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "LeftNavigationViewController.h"
#import "AppDelegate.h"
#import "Profile.h"
#import "NotificationViewController.h"
#import "FeedViewController.h"

@implementation LeftNavigationViewController

@synthesize scrollView;
@synthesize _profile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMyProfile:) name:@"gotMyProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAProfile:) name:@"gotProfile" object:nil];
    [self.scrollView setScrollsToTop:false];
}

-(void)gotMyProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotMyProfile"]) return;
    Profile* profile = notif.object;
    [self set_profile:profile];
}

-(void)gotAProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    Profile* profile = notif.object;
    if([profile.userId intValue] == [self._profile.userId intValue] && profile.photo){
        [self set_profile:profile];
        [self.profilePhoto setImage:profile.photo];
        [self.profilePhoto.layer setCornerRadius:50];
        [self.profilePhoto.layer setMasksToBounds:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotProfile" object:nil];
    }
}

-(IBAction) showNextView:(UIButton*)button{
    switch([button tag]){
        case 1:{
            NotificationViewController* notifController = (NotificationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"notificationView"];
            [notifController setProfile:self._profile];
            
            NSArray* objects  = [NSArray arrayWithObjects:notifController, @"notifController", nil];
            NSArray* keys  = [NSArray arrayWithObjects:@"childController", @"identifier", nil];
            NSDictionary* userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showNextView" object:notifController userInfo:userInfo];
            
        }
    }
    
}


@end
