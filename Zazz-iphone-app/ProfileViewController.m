//
//  ProfileViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"

@implementation ProfileViewController

@synthesize _profile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzProfile:) name:@"gotProfile" object:nil];
}

-(void)gotZazzProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    Profile* profile = [notif.userInfo objectForKey:@"profile"];
    [self set_profile:profile];
    NSLog(@"Welcome profileview: %@", profile.username);
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

#pragma mark - CFTabBarViewDelegate method

-(void)setViewHidden:(BOOL)hidden{
    [self.view.superview setHidden:hidden];
}


@end
