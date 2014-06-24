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

@implementation NotificationViewController

FeedViewController* feedViewController;
NSArray* requests;

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzFollowRequests:) name:@"gotFollowRequests" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAProfile:) name:@"gotProfile" object:nil];
    [[AppDelegate zazzApi] getFollowRequests];
}

-(void)gotZazzFollowRequests:(NSNotification*)notif{
    if(![notif.name isEqualToString:@"gotFollowRequests"])return;
    if(!requests)requests = [[NSArray alloc] initWithArray:notif.object];
    [self.tableView reloadData];
}

-(void)setParentViewController:(FeedViewController*)controller{
    feedViewController = controller;
}

-(IBAction)goBack:(UIButton*)backButton{
    [feedViewController animateBackToFeedView];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!requests) return 57;
    if([requests count]<1) return 48;
    return 58;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!requests || [requests count]<1) return 1;
    return [requests count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(!requests){
        cell = [tableView dequeueReusableCellWithIdentifier:@"waiting"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"waiting"];
        }
        [(UIActivityIndicatorView*)[cell viewWithTag:2] startAnimating];
        return cell;
    }
    if([requests count] < 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"noRequests"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noRequests"];
        }
        return cell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:@"requestCellPrototype"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requestCellPrototype"];
    }
    FollowRequest* request = (FollowRequest*)[requests objectAtIndex:indexPath.row];
    [(UILabel*)[cell viewWithTag:1] setText:request.user.username];
    [(UILabel*)[cell viewWithTag:2] setText:request.time];
    [(UIImageView*)[cell viewWithTag:3] setImage:request.user.photo];
    return cell;
    
    
}


-(void)gotAProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    [self.tableView reloadData];
}

@end
