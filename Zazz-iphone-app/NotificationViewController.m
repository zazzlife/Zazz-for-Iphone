//
//  NotificationViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/21/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "NotificationViewController.h"
#import "FeedViewController.h"
#import "AppDelegate.h"
#import "FollowRequest.h"
#import "Notification.h"

@implementation NotificationViewController

static const int CONDITION_NEWS_LOADING = 0;
static const int CONDITION_NO_NEWS = 1;
static const int CONDITION_HAVE_NEWS = 2;
static const int CONDITION_NOTIFICATIONS_LOADING = 3;
static const int CONDITION_NO_NOTIFICATIONS = 4;
static const int CONDITION_HAVE_NOTIFICATIONS = 5;

Profile* _profile;
FeedViewController* feedViewController;
BOOL seeing_requests = false;
NSArray* requests;
NSArray* notifications;

-(void)viewDidLoad{
    [super viewDidLoad];
    seeing_requests = false;
    [self.segmentedControl removeSegmentAtIndex:0 animated:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzFollowRequests:) name:@"gotFollowRequests" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzNotifications:) name:@"gotNotifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAProfile:) name:@"gotProfile" object:nil];
    [[AppDelegate zazzApi] getFollowRequests];
    [[AppDelegate zazzApi] getNotifications];
}

-(IBAction)goBack:(UIButton*)backButton{
    [feedViewController animateBackToFeedView];
}

-(IBAction)changeView:(UISegmentedControl*)sender{
    seeing_requests = false;
    if ([self.segmentedControl numberOfSegments] > 1 && [sender selectedSegmentIndex] == 0){
        seeing_requests = true;
    }
    [self.tableView reloadData];
}

/* TABLEVIEW DELEGATES */

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self getCondition]) {
        case CONDITION_NO_NOTIFICATIONS:
        case CONDITION_NO_NEWS:{return 48;}
        case CONDITION_NOTIFICATIONS_LOADING:
        case CONDITION_NEWS_LOADING:
        case CONDITION_HAVE_NOTIFICATIONS:
        case CONDITION_HAVE_NEWS:
        default:{return 58;}
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch ([self getCondition]) {
        case CONDITION_NOTIFICATIONS_LOADING:
        case CONDITION_NEWS_LOADING:
        case CONDITION_NO_NOTIFICATIONS:
        case CONDITION_NO_NEWS:{return 1;}
        case CONDITION_HAVE_NEWS:{return [notifications count];}
        case CONDITION_HAVE_NOTIFICATIONS:
        default:{return [requests count];}
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    switch ([self getCondition]) {
        case CONDITION_NOTIFICATIONS_LOADING:
        case CONDITION_NEWS_LOADING:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"waiting"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"waiting"];
            }
            [(UIActivityIndicatorView*)[cell viewWithTag:2] startAnimating];
            return cell;
        }
        case CONDITION_NO_NOTIFICATIONS:
        case CONDITION_NO_NEWS:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"noRequests"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noRequests"];
            }
            return cell;
        }
        case CONDITION_HAVE_NEWS:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
            }
            Notification* notif = (Notification*)[notifications objectAtIndex:indexPath.row];
            for(UIView* subview in cell.contentView.subviews){
//            NSLog(@"tag:%ld class:%@ restorationIdentifier: %@", (long)subview.tag, subview.class, [subview restorationIdentifier]);
                if([[subview restorationIdentifier] isEqualToString:@"userImage"]){
                    [(UIImageView*)subview setImage:notif.user.photo];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"displayName"]){
                    [(UILabel*)subview setText:notif.user.username];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"description"]){
                    [(UILabel*)subview setText:[ZazzApi formatDateString:notif.time]];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"auxView"]){
                    continue;
                }
            }
            return cell;
        }
        default:{//CONDITION_HAVE_NOTIFICATIONS
            cell = [tableView dequeueReusableCellWithIdentifier:@"requestCellPrototype"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requestCellPrototype"];
            }
            FollowRequest* request = (FollowRequest*)[requests objectAtIndex:indexPath.row];
            for(UIView* subview in cell.contentView.subviews){
                if([[subview restorationIdentifier] isEqualToString:@"userImage"]){
                    [(UIImageView*)subview setImage:request.user.photo];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"nameLabel"]){
                    [(UILabel*)subview setText:request.user.username];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"timeLabel"]){
                    [(UILabel*)subview setText:[ZazzApi formatDateString:request.time]];
                    continue;
                }
                [(UIButton*)subview setTag:indexPath.row];
                if([[subview restorationIdentifier] isEqualToString:@"confirmButton"]){
                    [(UIButton*)subview addTarget:self action:@selector(clickedConfirm:) forControlEvents:UIControlEventTouchDown];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"rejectButton"]){
                    [(UIButton*)subview addTarget:self action:@selector(clickedReject:) forControlEvents:UIControlEventTouchUpInside];
                    continue;
                }
            }
            return cell;
        }
    }
}



/* OTHER DELEGATES AND HELPERS */

-(void)gotZazzNotifications:(NSNotification*)notif{
    if(![notif.name isEqualToString:@"gotNotifications"])return;
    notifications = [[NSArray alloc] initWithArray:notif.object];
    [self.tableView reloadData];
}

-(void)gotZazzFollowRequests:(NSNotification*)notif{
    if(![notif.name isEqualToString:@"gotFollowRequests"])return;
    requests = [[NSArray alloc] initWithArray:notif.object];
    [self.tableView reloadData];
}

-(void)setParentViewController:(FeedViewController*)controller{
    feedViewController = controller;
}

-(int)getCondition{
    if(!seeing_requests && !notifications){
        return CONDITION_NEWS_LOADING;}
    if(!seeing_requests && [notifications count]<1){
        return CONDITION_NO_NEWS;}
    if(!seeing_requests){
        return CONDITION_HAVE_NEWS;}
    if(!requests){
        return CONDITION_NOTIFICATIONS_LOADING;}
    if([requests count] < 1){
        return CONDITION_NO_NOTIFICATIONS;}
    return CONDITION_HAVE_NOTIFICATIONS;
}

-(void)clickedConfirm:(id)sender{
    CGFloat index = [sender tag];
    FollowRequest* request = [requests objectAtIndex:index];
    NSLog(@"confirm %@",request.user.username);
}

-(void)clickedReject:(id)sender{
    CGFloat index = [sender tag];
    FollowRequest* request = [requests objectAtIndex:index];
    NSLog(@"reject %@",request.user.username);
}


-(void)gotAProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    [self.tableView reloadData];
}

-(void)set_profile:(Profile *)profile{
    //if(profile.is_public) return;
    if(!_profile)
        [self.segmentedControl insertSegmentWithTitle:@"Requests" atIndex:0 animated:1];
    _profile = profile;
}

@end
