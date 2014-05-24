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

@synthesize swipe_left;
@synthesize swipe_right;

bool left_active = false; // used by sideNav to indicate if it's open or not.
bool filter_active = false; // true if filter is expanded.
bool getting_height = false; //used by cellAtIndex and heightForRowAtIndex. True if getting height of cell to be rendered, false if cell is actually being rendered.
bool end_of_feed = false; //true if last feed fetch returned nothing.
bool _loaded = false; //prevents viewWillLoad from fetching initial feed multiple times.
bool showPhotos= true;
bool showEvents= true;



-(void)viewWillAppear:(BOOL)animated
{
    if (!_loaded){
        _loaded = YES;
        [[[AppDelegate getAppDelegate] zazzAPI] getMyFeedDelegate:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* IF WE MAKE TAB BAR CONTROLLER, MOVE THIS THERE INSTEAD*/
//    self.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 5, 10, 10);
//    UITabBar *tabBar = self.tabBarController.tabBar;
//    UITabBarItem *myItem = [tabBar.items objectAtIndex:0];
//    [myItem initWithTitle:@"" image:[UIImage imageNamed:@"Home_icon_general.png"] selectedImage:[UIImage imageNamed:@"Home_icon_general.png"]];
    
    [[AppDelegate getAppDelegate] removeZazzBackgroundLogo];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[AppDelegate colorFromHexString:@"#453F3F"]];
    
    swipe_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipe_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    
    swipe_left.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe_right.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe_left];
    [self.view addGestureRecognizer:swipe_right];
    
    [self setFeed:[[NSMutableArray alloc] init]];
    [self setNoPhotoFeed:[[NSMutableArray alloc] init]];
    [self setNoEventFeed:[[NSMutableArray alloc] init]];
    [self setNoPhotoNoEventFeed:[[NSMutableArray alloc] init]];
}

-(void)gotZazzFeed:(NSMutableArray*)feed
{
    int old_count = self.feed.count;
    [self.feed addObjectsFromArray:feed];
    for(Feed* feedItem in feed){
        if([feedItem.feedType  isEqualToString:@"Post"]){
            [self.noEventFeed addObject:feedItem];
            [self.noPhotoFeed addObject:feedItem];
            [self.noPhotoNoEventFeed addObject:feedItem];
        }
        if([feedItem.feedType isEqualToString:@"Photo" ]){
            [self.noEventFeed addObject:feedItem];
        }
        if([feedItem.feedType  isEqualToString:@"Event"]){
            [self.noPhotoFeed addObject:feedItem];
        }
    }
    end_of_feed = (self.feed.count <= old_count);
    [[self feedTableView] reloadData];
}

-(NSMutableArray*)getFilteredFeed{
    NSMutableArray* source_feed = self.feed;
    if(!showPhotos && showEvents){
        source_feed = self.noPhotoFeed;
    }else if(showPhotos && !showEvents){
        source_feed = self.noEventFeed;
    }else if(!showPhotos && !showEvents){
        source_feed = self.noPhotoNoEventFeed;
    }
    return source_feed;
}

-(void)didSwipeLeft:(UIGestureRecognizer *) recognizer
{
    if(!left_active) return;
    [self leftDrawerButton:nil];
}
-(void)didSwipeRight:(UIGestureRecognizer *) recognizer
{
    if(left_active) return;
    [self leftDrawerButton:nil];
}


#pragma mark - Interface Builder Actions

-(IBAction)leftDrawerButton:(id)sender
{
    if (!left_active){
        [self.tabBarController.view.superview addSubview:self.sideNav];
    }
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

-(IBAction)expandFilterCell:(id)sender
{
    filter_active = !filter_active;
    [self.feedTableView beginUpdates];
    [self.feedTableView endUpdates];
}

-(IBAction)toggleFilter:(id)sender
{
    if (((UISwitch*)sender).tag == 1){  showEvents = !showEvents; }
    else if(((UISwitch*)sender).tag == 2){ showPhotos = !showPhotos; }
    [[self feedTableView] reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* source_feed = [self getFilteredFeed];
    if(end_of_feed) return [source_feed count] + 1;
    return [source_feed count] + 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected");
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    getting_height = true;
    FeedTableViewCell* cell = (FeedTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    getting_height = false;
    if(indexPath.row == 0){
        if (filter_active) return 150;
        return 50;
    }
    NSMutableArray* source_feed = [self getFilteredFeed];
    if(indexPath.row == [source_feed count]+1){return 57;}
    return cell.needed_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* source_feed = [self getFilteredFeed];
    if (indexPath.row == 0){
        NSString* CellIdentifier = @"filterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UISwitch* eventToggle = (UISwitch*)[cell.contentView viewWithTag:1];
        UISwitch* photoToggle = (UISwitch*)[cell.contentView viewWithTag:2];
        
        [eventToggle setOn:showEvents];
        [photoToggle setOn:showPhotos];
        
        [[[cell.contentView viewWithTag:0] layer] setCornerRadius:5];
        [[[cell.contentView viewWithTag:0] layer]  setMasksToBounds:YES];
        return cell;
    }
    if(indexPath.row == [source_feed count]+1){
        NSString* CellIdentifier = @"feedMoreLoader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if(!getting_height && source_feed.count > 0){
            NSString* last_feedId = (NSString*)[(Feed*)[source_feed objectAtIndex:indexPath.row-2] feedId];
            [[[AppDelegate getAppDelegate] zazzAPI] getMyFeedAfter:[NSString stringWithFormat:@"%@",last_feedId] delegate:self];
        }
        return cell;
    }
    
    NSString *CellIdentifier = @"FeedTableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAutoresizingMask: UIViewAutoresizingFlexibleHeight];
    [cell setClipsToBounds:YES];
    Feed *feedItem = [source_feed objectAtIndex:[indexPath row]-1];
    [cell setFeed:feedItem];
    return cell;
}

@end
