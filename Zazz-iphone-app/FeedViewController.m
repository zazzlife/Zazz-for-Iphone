//
//  FeedTableViewController.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "AppDelegate.h"

@implementation FeedViewController

@synthesize recognizer_close_drawer;
@synthesize recognizer_open_drawer;
@synthesize navigationDrawerLeftWidth;
@synthesize navigationDrawerLeftX;

@synthesize UserImages = _UserImages;
@synthesize Usernames = _Usernames;
@synthesize TimeStamps = _TimeStamps;


BOOL left_active = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /* IF WE MAKE TAB BAR CONTROLLER, MOVE THIS THERE INSTEAD*/
//    self.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 5, 10, 10);
//    UITabBar *tabBar = self.tabBarController.tabBar;
//    UITabBarItem *myItem = [tabBar.items objectAtIndex:0];
    
//    [myItem initWithTitle:@"" image:[UIImage imageNamed:@"Home_icon_general.png"] selectedImage:[UIImage imageNamed:@"Home_icon_general.png"]];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[AppDelegate colorFromHexString:@"#453F3F"]];
    
    recognizer_open_drawer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipes:)];
    recognizer_close_drawer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipes:)];
    
    recognizer_close_drawer.direction = UISwipeGestureRecognizerDirectionLeft;
    recognizer_open_drawer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:recognizer_open_drawer];
    [self.view addGestureRecognizer:recognizer_close_drawer];
    
    [self.loginprogress setColor:[UIColor yellowColor]];
    [self.loginprogress startAnimating];
    
    [self setFeed:[[NSMutableArray alloc] init]];
    
    [[[AppDelegate getAppDelegate] zazzAPI] getMyFeedDelegate:self];
}

-(void)gotZazzFeed:(NSMutableArray*)feed{
    [[AppDelegate getAppDelegate] removeZazzBackgroundLogo];
    [self setFeed:feed];
    [[self feedTableView] reloadData];
    [self.loginprogress stopAnimating];
    
    self.loginprogress.hidden = YES;
    
    [self.sideNav setFrame:CGRectMake(-200, 0, 200, self.view.frame.size.height)];
    
}


-(void)doSwipes:(UIGestureRecognizer *) sender {
    [self leftDrawerButton:nil];
}

-(IBAction)leftDrawerButton:(id)sender {
    if (!left_active){
        [self.tabBarController.view.superview addSubview:self.sideNav];
    }
    NSLog(@"%d",self.tabBarController.view.superview.subviews.count);
    [self navigationDrawerAnimation];
    
}
-(void)navigationDrawerAnimation {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:-10];
    
    if(!left_active){
        [self.tabBarController.view setFrame:CGRectMake(200, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.sideNav setFrame:CGRectMake(0, 0, 200, self.view.frame.size.height)];
        left_active = true;
    }else{
        [self.tabBarController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.sideNav setFrame:CGRectMake(-200, 0, 200, self.view.frame.size.height)];
        left_active = false;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self feed] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell* cell = (FeedTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 0) return 55;
    return cell.needed_height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        NSString* CellIdentifier = @"filterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [[[cell.contentView viewWithTag:1] layer] setCornerRadius:5];
        [[[cell.contentView viewWithTag:1] layer]  setMasksToBounds:YES];
        return cell;
    }
    
    NSString *CellIdentifier = @"FeedTableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAutoresizingMask: UIViewAutoresizingFlexibleHeight];
    [cell setClipsToBounds:YES];
    Feed *feedItem = [[self feed] objectAtIndex:[indexPath row]-1];
    [cell setFeed:feedItem];
    return cell;
}

@end
