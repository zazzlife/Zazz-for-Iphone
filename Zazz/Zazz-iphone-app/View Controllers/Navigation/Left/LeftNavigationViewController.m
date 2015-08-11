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
#import "UIImageView+WebCache.h"

@implementation LeftNavigationViewController

@synthesize scrollView;
@synthesize _user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMe:) name:@"gotMe" object:nil];
    self.background.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    [self.scrollView setScrollsToTop:false];
}

-(void)gotMe:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotMe"]) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotMe" object:nil];
    User* user = notif.object;
    [self set_user:user];
    [self.profilePhoto setImageWithURL:[NSURL URLWithString:user.photoUrl]];
    [self.profilePhoto.layer setCornerRadius:50];
    [self.profilePhoto.layer setMasksToBounds:YES];
}

-(IBAction) showNextView:(UIButton*)button{
    switch([button tag]){
        case 1:{
            NotificationViewController* notifController = (NotificationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"notificationView"];
            [notifController setUser:self._user];
            
            NSArray* objects  = [NSArray arrayWithObjects:notifController, @"notifController", nil];
            NSArray* keys  = [NSArray arrayWithObjects:@"childController", @"identifier", nil];
            NSDictionary* userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showNextView" object:notifController userInfo:userInfo];
            
        }
    }
    
}


@end
