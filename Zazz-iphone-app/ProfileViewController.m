//
//  ProfileViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ProfileViewController.h"
#import "FeedTableViewController.h"
#import "AppDelegate.h"

@implementation ProfileViewController

@synthesize _profile;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView setScrollsToTop:false];
    [self.scrollView setAlwaysBounceVertical:false];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMyProfile:) name:@"gotMyProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAProfile:) name:@"gotProfile" object:nil];
}

-(void)gotMyProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotMyProfile"]) return;
    Profile* profile = notif.object;
    [self set_profile:profile];
    [self.username setText:profile.username];
//    [self.name setText:profile.displayName];
}

-(void)gotAProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    Profile* profile = notif.object;
    if([profile.userId intValue] == [self._profile.userId intValue] && profile.photo){
        [self set_profile:profile];
        [self.profilePhoto setImage:profile.photo];
        [self.profilePhoto.layer setCornerRadius:self.profilePhoto.frame.size.height / 2];
        [self.profilePhoto.layer setMasksToBounds:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotProfile" object:nil];
    }
}

#pragma mark - CFTabBarViewDelegate method
-(void)setViewHidden:(BOOL)hidden{
    [self.view.superview setHidden:hidden];
    [self.feedTableViewController.tableView setScrollsToTop:true ];
    if(hidden){
        [self.feedTableViewController.tableView setScrollsToTop:false ];
    }
}


-(void)scrollViewToTopIfNeeded:(UIScrollView*)scrollView{
    float filter_bottom_y = CGRectGetMaxY(self.filterButtons.frame);
    float delta = scrollView.contentOffset.y;
    if(delta > 0 && delta < filter_bottom_y){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    float delta = scrollView.contentOffset.y;
    if(delta <= 0){
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    else if(delta < CGRectGetMaxY(self.filterButtons.frame)){
        [self.scrollView setContentOffset:CGPointMake(0, delta)];
    }
    else if (delta >= CGRectGetMaxY(self.filterButtons.frame)){
        [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(self.filterButtons.frame))];
    }
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if(![segue.identifier isEqualToString:@"embedFeedViewController"]) return;
    FeedTableViewController* feedController = (FeedTableViewController*)segue.destinationViewController;
    [self setFeedTableViewController:feedController];
    [feedController setFeed_user_id:self._profile.userId];
    [feedController setScrollDelegate:self];
}


@end
