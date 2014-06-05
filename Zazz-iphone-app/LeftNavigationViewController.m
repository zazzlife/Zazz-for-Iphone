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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppDelegate zazzApi] getMyProfileDelegate:self];
}

-(void)gotZazzProfile:(Profile *)profile{
    [self set_profile:profile];
    [self.profilePhoto setImage:[profile photo]];
    [self.profilePhoto.layer setCornerRadius:50];
    [self.profilePhoto.layer setMasksToBounds:YES];
    NSLog(@"Welcome: %@", profile.username);
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
