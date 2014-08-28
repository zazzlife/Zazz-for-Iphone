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
#import "UIImageView+WebCache.h"

@implementation ProfileViewController

@synthesize user_id;
@synthesize _profile;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView setScrollsToTop:false];
    [self.scrollView setAlwaysBounceVertical:false];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMe:) name:@"gotMe" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotProfile:) name:@"gotProfile" object:nil];
}

-(void)gotMe:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotMe"]) return;
    User* user = notif.object;
    [self setUser_id:user.userId];
    [[AppDelegate zazzApi] getProfile:user_id];
}

-(void)gotProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    Profile* profile = notif.object;
    if([profile.profile_id intValue] == [self.user_id intValue]){
        [self set_profile:profile];
        [self.profilePhoto setImageWithURL:profile.photoUrl];
        [self.profilePhoto.layer setCornerRadius:self.profilePhoto.frame.size.height / 2];
        [self.profilePhoto.layer setMasksToBounds:YES];
        [self.username setText:[NSString stringWithFormat:@"@%@",profile.displayName]];
        [self.name setText:profile.userDetails.fullName];
        [self.tagline setText:profile.userDetails.major.name];
        [self.school setText:profile.userDetails.school.name];
        [self.city setText:profile.userDetails.city.name];
        if(!profile.isCurrentUserFollowingTargetUser){
            [self.follow setTitle:@"Following" forState:UIControlStateNormal];
        }
        [self.followers setText:[NSString stringWithFormat:@"%d",profile.followersCount]];
//        [self.following setText:profile.]
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
    if(![segue.identifier isEqualToString:@"embedProfileFeedViewController"]) return;
    FeedTableViewController* feedController = (FeedTableViewController*)segue.destinationViewController;
    [self setFeedTableViewController:feedController];
    [feedController setFeed_user_id:self._profile.profile_id];
    [feedController setScrollDelegate:self];
}


@end
