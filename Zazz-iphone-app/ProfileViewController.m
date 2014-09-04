//
//  ProfileViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ProfileViewController.h"
#import "FeedTableViewController.h"
#import "MediaFeedViewController.h"
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

-(void)viewWillAppear:(BOOL)animated{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
//    [self scrollViewDidScroll:self.feedTableViewController.tableView];
}

-(IBAction)changeFeed:(UISegmentedControl*)sender{
    int segment = [sender selectedSegmentIndex];
    if(segment == 0){
        [self.feedTableViewController setShowPosts:false];
        [self.feedTableViewController setShowEvents:false];
        [self.feedTableViewController setShowPhotos:true];
        [self.feedTableViewController setShowVideos:true];
        [self.mediaFeedViewController.collectionView reloadData];
        [self.mediaFeedView setHidden:false];
        [self.mediaFeedViewController.collectionView setScrollEnabled:true];
        [self.postFeedView setHidden:true];
        [self.feedTableViewController.tableView setScrollEnabled:false];
    }else{
        [self.feedTableViewController setShowPosts:true];
        [self.feedTableViewController setShowEvents:true];
        [self.feedTableViewController setShowPhotos:false];
        [self.feedTableViewController setShowVideos:false];
        [self.feedTableViewController.tableView reloadData];
        [self.mediaFeedView setHidden:true];
        [self.mediaFeedViewController.collectionView setScrollEnabled:false];
        [self.postFeedView setHidden:false];
        [self.feedTableViewController.tableView setScrollEnabled:true];
    }
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
        [self.profilePhoto setImageWithURL:[NSURL URLWithString:profile.photoUrl]];
        [self.profilePhoto.layer setCornerRadius:self.profilePhoto.frame.size.height / 2];
        [self.profilePhoto.layer setMasksToBounds:YES];
        [self.username setText:[NSString stringWithFormat:@"@%@",profile.displayName]];
        [self.name setText:profile.userDetails.fullName];
        [self.tagline setText:profile.userDetails.major.name];
        [self.school setText:profile.userDetails.school.name];
        [self.city setText:profile.userDetails.city.name];
        [self.followers setText:[NSString stringWithFormat:@"%@",profile.followersCount]];
        if(!profile.isCurrentUserFollowingTargetUser){
            [self.follow setTitle:@"Following" forState:UIControlStateNormal];
        }
        [self embedFeedTableViewController];
    }
}

#pragma mark - CFTabBarViewDelegate method
-(void)setViewHidden:(BOOL)hidden{
    [self.view.superview setHidden:hidden];
    [self.feedTableViewController.tableView setScrollsToTop:true ];
    if(hidden){
        [self.mediaFeedViewController.collectionView setScrollsToTop:false];
        [self.feedTableViewController.tableView setScrollsToTop:false ];
    }
}

/* SCROLL DELEGATION BROKEN... TODO-fix it */
//-(void)scrollViewToTopIfNeeded:(UIScrollView*)scrollView{
//    float filter_bottom_y = CGRectGetMaxY(self.topContainer.frame);
//    float delta = scrollView.contentOffset.y;
//    if(delta > 0 && delta < filter_bottom_y){
//        [self.scrollView setContentOffset:CGPointZero animated:YES];
//        [scrollView setContentOffset:CGPointZero animated:YES];
//    }
//}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    float filter_view_height = CGRectGetMaxY(self.topContainer.frame);
    float delta = scrollView.contentOffset.y;
    if(delta <= 0){
        [self.scrollView setContentOffset:CGPointZero];
    }
    else if(delta < filter_view_height){
        [self.scrollView setContentOffset:CGPointMake(0, delta)];
    }
    else if (delta >= filter_view_height){
        [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(self.topContainer.frame))];
    }
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"embedProfileFeedViewController"]){
        [self setFeedTableViewController:(FeedTableViewController*)segue.destinationViewController];
    }else if([segue.identifier isEqualToString:@"embedProfileFeedMediaViewController"]){
        [self setMediaFeedViewController:(MediaFeedViewController*)segue.destinationViewController];
    }
    [self embedFeedTableViewController];
}

-(void)embedFeedTableViewController{
    if(!(self.feedTableViewController && self._profile && self.mediaFeedViewController))
        return;
    
    [self.feedTableViewController setFeed_user_id:self._profile.profile_id];
    [self.feedTableViewController setScrollDelegate:self];
    [self.feedTableViewController initFeedViewController];
    [self.feedTableViewController setShowPosts:true];
    
    [self.mediaFeedViewController setScrollDelegate:self];
    [self.mediaFeedViewController setFeedTableViewController:self.feedTableViewController];
    [self.mediaFeedViewController viewDidEmbed];
    
}


@end
