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


@implementation LeftNavigationViewController

@synthesize _profile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMyProfile:) name:@"gotMyProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAProfile:) name:@"gotProfile" object:nil];
}
-(void)gotMyProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotMyProfile"]) return;
    Profile* profile = notif.object;
    NSLog(@"welcome leftNav: %@",profile.username);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
