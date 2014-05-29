//
//  FeedTableViewController.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "Feed.h"
#import "AppDelegate.h"
#import "UIImage.h"
#import "UIColor.h"

@implementation FeedViewController

@synthesize swipe_left;
@synthesize swipe_right;

bool left_active = false; // used by leftNav to indicate if it's open or not.
bool right_active = false; // used by leftNav to indicate if it's open or not.
bool filter_active = false; // true if filter is expanded.
bool getting_height = false; //used by cellAtIndex and heightForRowAtIndex. True if getting height of cell to be rendered, false if cell is actually being rendered.
bool end_of_feed = false; //true if last feed fetch returned nothing.
bool _loaded = false; //prevents viewWillLoad from fetching initial feed multiple times.
bool showPhotos= false;
bool showEvents= false;
bool showVideos= false;

float SIDE_DRAWER_ANIMATION_DURATION = .1;


/*
 The view has a sense of self and
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[AppDelegate getAppDelegate] zazzAPI] getMyFeedDelegate:self];
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
//    
    UIColor* color = [UIColor colorFromHexString:@"#101010"];
    UIImage* coloredImage = [UIImage imageWithColor:color width:320 andHeight:49];
    [self.tabBarController.tabBar setBackgroundImage:coloredImage];
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"post button.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"post button.png"]];
}

/* 
 Here you can actualy use view Geometry to do calculation and add subview the the tabBar view's superview.
 ViewDidLoad is too early for this, as the view hasn't been rendered yet, or added into it's parent tabbar container.
 */
-(void) viewDidAppear:(BOOL)animated{
    if(!_loaded){
        //first call is made by nav controller... too early here...
        _loaded = true;
        return;
    }
}

-(void)gotZazzFeed:(NSMutableArray*)feed
{
    if([feed count] <= 0){
        end_of_feed = true;
        [[self feedTableView] reloadData];
        return;
    }
    [self.feed addObjectsFromArray:feed];
    [self setFilteredFeed:[self getFilteredFeed]];
    [[self feedTableView] reloadData];
}

-(void)didSwipeLeft:(UIGestureRecognizer *) recognizer
{
    if(right_active) return;
    if(left_active){
        [self leftDrawerButton:nil];
        return;
    }
    //else: neither active
    [self rightDrawerButton:nil];
}
-(void)didSwipeRight:(UIGestureRecognizer *) recognizer
{
    if(left_active) return;
    if(right_active){
        [self rightDrawerButton:nil];
        return;
    }
    [self leftDrawerButton:nil];
}

/* Should be optimized */
-(NSArray*)getFilteredFeed{
    NSLog(@"START FILTER");
    NSIndexSet *indices = [self.feed indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        Feed* feedItem = (Feed*) obj;
        if(!showEvents && !showPhotos && !showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Photo"] && showPhotos) return true;
        if([feedItem.feedType isEqualToString:@"Video"] && showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Event"] && showEvents) return true;
        return false;
    }];
    NSLog(@"STOP");
    return [self.feed objectsAtIndexes:indices];
}


#pragma mark - Interface Builder Actions

-(IBAction)rightDrawerButton:(id)sender
{
    CGFloat rightNavWidth =self.rightNav.frame.size.width;
        
    if(left_active) [self leftDrawerButton:nil];//close left drawer first.

    [self.rightNav setFrame:CGRectMake(self.view.window.frame.size.width, 0, self.rightNav.frame.size.width, self.view.window.frame.size.height)];
    [self.rightNav setHidden:false];
    [self.tabBarController.view.superview addSubview:self.rightNav];
    
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:SIDE_DRAWER_ANIMATION_DURATION];
    
    if(!right_active){
        [self.tabBarController.view setFrame:CGRectMake(-rightNavWidth, 0, self.view.window.frame.size.width, self.view.window.frame.size.height)];
        [self.rightNav setFrame:CGRectMake(self.view.window.frame.size.width - rightNavWidth, 0, rightNavWidth, self.view.window.frame.size.height)];
        right_active = true;
    }else{
        [self.tabBarController.view setFrame:CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height)];
        [self.rightNav setFrame:CGRectMake(self.view.window.frame.size.width, 0, rightNavWidth, self.view.window.frame.size.height)];
        right_active = false;
    }
    [UIView setAnimationsEnabled:NO];
}

-(IBAction)leftDrawerButton:(id)sender
{
    CGFloat leftNavWidth =self.leftNav.frame.size.width;
    
    if(right_active) [self rightDrawerButton:nil]; //close right drawer first.
    
    [self.leftNav setFrame:CGRectMake(-(self.leftNav.frame.size.width), 0, self.leftNav.frame.size.width, self.view.window.frame.size.height)];
    [self.leftNav setHidden:false];
    [self.tabBarController.view.superview addSubview:self.leftNav];
    
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:SIDE_DRAWER_ANIMATION_DURATION];
    
    if(!left_active){
        [self.tabBarController.view setFrame:CGRectMake(leftNavWidth, 0, self.view.window.frame.size.width, self.view.window.frame.size.height)];
        [self.leftNav setFrame:CGRectMake(0, 0, leftNavWidth, self.view.window.frame.size.height)];
        left_active = true;
    }else{
        [self.tabBarController.view setFrame:CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height)];
        [self.leftNav setFrame:CGRectMake(-leftNavWidth, 0, leftNavWidth, self.view.window.frame.size.height)];
        left_active = false;
    }
    [UIView setAnimationsEnabled:NO];
}

-(IBAction)expandFilterCell:(id)sender
{
    filter_active = !filter_active;
    [UIView setAnimationsEnabled:YES];
    [self.feedTableView beginUpdates];
    [self.feedTableView endUpdates];
    [UIView setAnimationsEnabled:NO];
}

-(IBAction)toggleFilter:(id)sender
{
    if (((UISwitch*)sender).tag == 1){  showVideos = !showVideos; }
    else if(((UISwitch*)sender).tag == 2){ showPhotos = !showPhotos; }
    else if(((UISwitch*)sender).tag == 3){ showEvents = !showEvents; }
    [self setFilteredFeed:[self getFilteredFeed]];
    [[self feedTableView] reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* source_feed = self.filteredFeed;
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
        if (filter_active) return 170;
        return 50;
    }
    NSArray* source_feed = self.filteredFeed;
    if(indexPath.row == [source_feed count]+1){return 57;}
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
        
        [(UISwitch*)[cell.contentView viewWithTag:1] setOn:showVideos];
        [(UISwitch*)[cell.contentView viewWithTag:2] setOn:showPhotos];
        [(UISwitch*)[cell.contentView viewWithTag:3] setOn:showEvents];
        
        [[[cell.contentView viewWithTag:5] layer] setCornerRadius:5];
        [[[cell.contentView viewWithTag:5] layer] setMasksToBounds:YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    if(indexPath.row == [self.filteredFeed count]+1){
        NSString* CellIdentifier = @"feedMoreLoader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if(!getting_height && !end_of_feed){
            NSString* last_feedId = (NSString*)[(Feed*)self.feed.lastObject feedId];
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
    Feed *feedItem = [self.filteredFeed objectAtIndex:(indexPath.row - 1)];
    [cell setFeed:feedItem];
    return cell;
}

@end
