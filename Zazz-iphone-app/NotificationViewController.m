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

static const BOOL ACCEPT = true;
static const BOOL REJECT = !ACCEPT;

static const int CONDITION_NOTIFICATIONS_LOADING = 0;
static const int CONDITION_NOTIFICATIONS_NONE = 1;
static const int CONDITION_NOTIFICATIONS_SOME = 2;
static const int CONDITION_REQUESTS_LOADING = 3;
static const int CONDITION_REQUESTS_NONE = 4;
static const int CONDITION_REQUESTS_SOME = 5;

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
    [self.tableViewController.tableView reloadData];
}

/* TABLEVIEW DELEGATES */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int cond = [self getCondition];
    switch (cond) {
        case CONDITION_REQUESTS_LOADING:
        case CONDITION_NOTIFICATIONS_LOADING:
        case CONDITION_REQUESTS_NONE:
        case CONDITION_NOTIFICATIONS_NONE:{return 1;}
        case CONDITION_NOTIFICATIONS_SOME:{return [notifications count];}
        case CONDITION_REQUESTS_SOME:
        default:{return [requests count];}
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int cond = [self getCondition];
    switch (cond) {
        case CONDITION_REQUESTS_NONE:
        case CONDITION_NOTIFICATIONS_NONE:{return 48;}
        case CONDITION_REQUESTS_LOADING:
        case CONDITION_NOTIFICATIONS_LOADING:
        case CONDITION_REQUESTS_SOME:
        case CONDITION_NOTIFICATIONS_SOME:
        default:{return 58;}
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    int cond = [self getCondition];
    switch (cond) {
        case CONDITION_REQUESTS_LOADING:
        case CONDITION_NOTIFICATIONS_LOADING:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"waiting"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"waiting"];
            }
            [(UIActivityIndicatorView*)[cell viewWithTag:2] startAnimating];
            return cell;
        }
        case CONDITION_REQUESTS_NONE:
        case CONDITION_NOTIFICATIONS_NONE:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"noRequests"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noRequests"];
            }
            return cell;
        }
        case CONDITION_NOTIFICATIONS_SOME:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
            }
            Notification* notif = (Notification*)[notifications objectAtIndex:indexPath.row];
            for(UIView* subview in cell.contentView.subviews){
//            NSLog(@"tag:%ld class:%@ restorationIdentifier: %@", (long)subview.tag, subview.class, [subview restorationIdentifier]);
                    if([[subview restorationIdentifier] isEqualToString:@"notifictionUserImage"]){
                    [(UIImageView*)subview setImage:notif.user.photo];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"displayName"]){
                    [(UILabel*)subview setText:notif.user.username];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"time"]){
                    [(UILabel*)subview setText:[ZazzApi formatDateString:notif.time]];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"description"]){
                    NSString* text;
                    NSLog(@"DISPLAYING %d from %@", notif.notificationType, notif.user.username);
                    switch ([notif notificationType]) {
                        case FollowRequestAccepted:
                            text = @"Accepted your friend request";
                            break;
                        case CommentOnPhoto:
                            text = @"Commented on your photo";
                            break;
                        case CommentOnPost:
                            text = @"Commented on your post";
                            break;
                        case WallPost:
                            text = @"Sent you a post";
                            break;
                        case CommentOnEvent:
                            text = @"Commented on your event";
                            break;
                        case NewEvent:
                        default:
                            text = @"Invited you to an event";
                            break;
                    }
                    [(UILabel*)subview setText:text];
                    continue;
                }
                if([[subview restorationIdentifier] isEqualToString:@"auxView"]){
//                    UIImage* image = [UIImage imageNamed:@"like_in_notifications"];
//                    UIImage* image = [UIImage imageNamed:@"tag_in_notifications"];
                    UIImage* image;
                    UIImageView* imageView;
                    switch ([notif notificationType]) {
                        case FollowRequestAccepted:
                            image = [UIImage imageNamed:@"Packed"];
                            imageView = [[UIImageView alloc] initWithImage:image];
                            [imageView setFrame:subview.bounds];
                            [subview addSubview:imageView];
                            break;
                        case CommentOnPhoto:
                            image = ((Photo*)notif.content).image;
                            imageView = [[UIImageView alloc] initWithImage:image];
                            [imageView setFrame:subview.bounds];
                            [subview addSubview:imageView];
                            continue;
                        case CommentOnPost:
                            image = [UIImage imageNamed:@"comment_in_notifications"];
                            imageView = [[UIImageView alloc] initWithImage:image];
                            [imageView setFrame:subview.bounds];
                            [subview addSubview:imageView];
                            continue;
                        case WallPost:
                            image = [UIImage imageNamed:@"comment_in_notifications"];
                            imageView = [[UIImageView alloc] initWithImage:image];
                            [imageView setFrame:subview.bounds];
                            [subview addSubview:imageView];
                            continue;
                        case CommentOnEvent:
                            image = [UIImage imageNamed:@"newEvent_in_notifications"];
                            imageView = [[UIImageView alloc] initWithImage:image];
                            [imageView setFrame:subview.bounds];
                            [subview addSubview:imageView];
                            continue;
                        case NewEvent:
                        default:
                            image = [UIImage imageNamed:@"newEvent_in_notifications"];
                            imageView = [[UIImageView alloc] initWithImage:image];
                            [imageView setFrame:subview.bounds];
                            [subview addSubview:imageView];
                            continue;
                    }
                }
            }
            return cell;
        }
        case CONDITION_REQUESTS_SOME:
        default:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"requestCellPrototype"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requestCellPrototype"];
            }
            FollowRequest* request = (FollowRequest*)[requests objectAtIndex:indexPath.row];
            for(UIView* subview in cell.contentView.subviews){
                    if([[subview restorationIdentifier] isEqualToString:@"requestUserImage"]){
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
            NSLog(@"requestUser: %@",request.user.username);
            return cell;
        }
    }
}



/* OTHER DELEGATES AND HELPERS */


-(void)beginRefreshView:(UIRefreshControl*)refresh {
    [refresh setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Updating"]];
    [refresh beginRefreshing];
    if (seeing_requests){
        requests = nil;
        [[AppDelegate zazzApi] getFollowRequests];
        return;
    }
    notifications = nil;
    [[AppDelegate zazzApi] getNotifications];
}
-(void)gotZazzNotifications:(NSNotification*)notif{
    if(![notif.name isEqualToString:@"gotNotifications"])return;
    notifications = [[NSArray alloc] initWithArray:notif.object];
    [self endRefreshView];
}
-(void)gotZazzFollowRequests:(NSNotification*)notif{
    if(![notif.name isEqualToString:@"gotFollowRequests"])return;
    requests = [[NSArray alloc] initWithArray:notif.object];
    [self endRefreshView];
}
-(void)endRefreshView{
    NSLog(@"gotZazzFollowRequests: %lu",[requests count]);
    [self.tableViewController.refreshControl endRefreshing];
    [self.tableViewController.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Pull To Update"]];
    [self.tableViewController.tableView reloadData];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"embedNotificationTable"]) {
        UITableViewController * tableViewController = (UITableViewController *) [segue destinationViewController];
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        [refresh setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Pull To Update"]];
        [refresh addTarget:self action:@selector(beginRefreshView:) forControlEvents:UIControlEventValueChanged];
        [tableViewController setRefreshControl:refresh];
        [tableViewController.tableView setDelegate:self];
        [tableViewController.tableView setDataSource:self];
        [tableViewController.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [tableViewController.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self setTableViewController:tableViewController];
    }
}

-(void)setParentViewController:(FeedViewController*)controller{
    feedViewController = controller;
}

-(int)getCondition{
    if(!seeing_requests && !notifications){
        return CONDITION_NOTIFICATIONS_LOADING;}
    if(!seeing_requests && [notifications count]<1){
        return CONDITION_NOTIFICATIONS_NONE;}
    if(!seeing_requests){
        return CONDITION_NOTIFICATIONS_SOME;}
    if(!requests){
        return CONDITION_REQUESTS_LOADING;}
    if([requests count] < 1){
        return CONDITION_REQUESTS_NONE;}
    return CONDITION_REQUESTS_SOME;
}

-(void)clickedConfirm:(id)sender{
    CGFloat index = [sender tag];
    FollowRequest* request = [requests objectAtIndex:index];
    [[AppDelegate zazzApi] setFollowRequestsUserId:request.user.userId action:ACCEPT];
    [[AppDelegate zazzApi] getFollowRequests];
}

-(void)clickedReject:(id)sender{
    CGFloat index = [sender tag];
    FollowRequest* request = [requests objectAtIndex:index];
    [[AppDelegate zazzApi] setFollowRequestsUserId:request.user.userId action:REJECT];
    [[AppDelegate zazzApi] getFollowRequests];
}


-(void)gotAProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    [self.tableViewController.tableView reloadData];
}

-(void)set_profile:(Profile *)profile{
    //if(profile.is_public) return;
    if(!_profile)
        [self.segmentedControl insertSegmentWithTitle:@"Requests" atIndex:0 animated:1];
    _profile = profile;
}

@end
