    //
//  FeedTableViewController.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "CFTabBarController.h"
#import "DetailViewController.h"
#import "Feed.h"
#import "Photo.h"
#import "AppDelegate.h"
#import "UIImage.h"
#import "UIView.h"
#import "UIColor.h"

@implementation FeedViewController

@synthesize swipe_left;
@synthesize swipe_right;
@synthesize active_category_id;
@synthesize categoryFeeds;
@synthesize filteredFeed;

bool clear_feed = false; //used when refreshing the feed to clear all seen feeds.
bool left_active = false; // used by leftNav to indicate if it's open or not.
bool right_active = false; // used by leftNav to indicate if it's open or not.
bool filter_active = false; // true if filter is expanded.
bool getting_feed = false; //true when a getZazzFeed call is active.
bool end_of_feed = false; //true if last feed fetch returned nothing.
bool showPhotos= false;
bool showEvents= false;
bool showVideos= false;
NSString* last_feed_id;
NSString* active_identifier = @""; //used to indentify which ViewController is currently inside nextView
NSMutableDictionary* _indexPathsToReload;

float SIDE_DRAWER_ANIMATION_DURATION = .3;

/*
 The view has a sense of self and
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _indexPathsToReload = [[NSMutableDictionary alloc] init];
    [self setCategoryFeeds:[[NSMutableDictionary alloc] init]];
    [self setFeed:[[NSMutableArray alloc] init]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotPhotoImageNotification:) name:@"gotPhotoImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzFeed:) name:@"gotFeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextView:) name:@"showNextView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHome:) name:@"showHome" object:nil];
    
    [self getFeedAfter:NULL];
    
    swipe_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipe_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipe_left.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe_right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe_left];
    [self.view addGestureRecognizer:swipe_right];
    
    [AppDelegate removeZazzBackgroundLogo];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [UIView setAnimationsEnabled:false];
    [self resetSlidingViews];
    [self getFeedAfter:NULL];
    clear_feed = true;
}

-(void)resetSlidingViews{
    UIToolbar* tabBar = [[[AppDelegate getAppDelegate] appTabBar] tabBar];
    CGFloat tabBarHeight = tabBar.frame.size.height;
    [self.leftNav setFrame:CGRectMake(-CGRectGetWidth(self.leftNav.frame), 0, CGRectGetWidth(self.leftNav.frame), CGRectGetHeight(self.view.window.frame))];
    [self.navFeedView setFrame:CGRectMake(0,0, CGRectGetWidth(self.view.window.frame), CGRectGetHeight(self.view.window.frame) - tabBarHeight)];
    [self.rightNav setFrame:CGRectMake(CGRectGetMaxX(self.navFeedView.frame), 0, CGRectGetWidth(self.rightNav.frame), CGRectGetHeight(self.view.window.frame))];
    [tabBar setFrame:CGRectMake(0, CGRectGetMaxY(self.navFeedView.frame),CGRectGetWidth(tabBar.frame),tabBarHeight)];

    //they were hidden because the push animation looked weird when they are visible from the start.
    [self.rightNav setHidden:false];
    [self.leftNav setHidden:false];
}

-(void)gotZazzFeed:(NSNotification *)notif{
    if (![notif.name isEqualToString:@"gotFeed"]) return;
    NSMutableArray* feed = [notif.userInfo objectForKey:@"feed"];
    if (!feed) return;
    
    if(clear_feed){[self.feed removeAllObjects]; clear_feed = false;}
    end_of_feed = false;
    getting_feed = false;
    if([feed count] <= 0){
        end_of_feed = true;
        [[self feedTableView] reloadData];
        return;
    }
    if(self.active_category_id){
        NSMutableArray* catFeed = [self.categoryFeeds objectForKey:self.active_category_id];
        if(!catFeed){
            [self.categoryFeeds setObject:[[NSMutableArray alloc] init] forKey:self.active_category_id];
            catFeed = [self.categoryFeeds objectForKey:self.active_category_id];
        }
        [catFeed addObjectsFromArray:feed];
        [self setFilteredFeed:[self getFilteredFeed]];
        [[self feedTableView] reloadData];
        return;
    }
    [self.feed addObjectsFromArray:feed];
    [self setFilteredFeed:[self getFilteredFeed]];
    [self.feedTableView reloadData];
}

-(void)didSwipeLeft:(UIGestureRecognizer *) recognizer{
    if(right_active) return;
    if(left_active){
        [self leftDrawerButton:nil];
        return;
    }
    //else: neither active
    [self rightDrawerButton:nil];
}
-(void)didSwipeRight:(UIGestureRecognizer *) recognizer{
    if(left_active) return;
    if(right_active){
        [self rightDrawerButton:nil];
        return;
    }
    [self leftDrawerButton:nil];
}

/**
    This function handlers adding and removing the active Category from active_category_id. 
    Returns true if new_category_id was added, false if it was removed.
 */
-(BOOL)setActiveCategory:(NSString*)new_category_id{
    BOOL retVal;
    end_of_feed = false;
    
    NSLog(@"before - ids: %@",active_category_id);
    NSMutableArray *ids = [[NSMutableArray alloc] initWithArray:[active_category_id componentsSeparatedByString:@","]];
    NSUInteger index = NSNotFound;
    for(int idx = 0; idx < ids.count; idx++){
        NSString* anId = [ids objectAtIndex:idx];
        if([anId intValue] == [new_category_id intValue]){
            index = idx;
            continue;
        }
    }
    if (index == NSNotFound){
        [ids addObject:new_category_id];
        retVal = true;
    }else{
        [ids removeObjectAtIndex:index];
        retVal = false;
    }
    NSArray* sortedIds = [ids sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        if([obj1 intValue] >  [obj2 intValue]) return 1;
        if([obj1 intValue] <  [obj2 intValue]) return -1;
        return 0;
    }];
    active_category_id = [sortedIds componentsJoinedByString:@","];
    NSLog(@"after ids: %@", active_category_id);
    if([active_category_id isEqualToString:@""]){
        active_category_id = nil;
        NSLog(@"nilled");
    }
    [self setFilteredFeed:[self getFilteredFeed]];
    [self.feedTableView reloadData];
    return retVal;
}

-(void)showNextView:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"showNextView"]) return;
    if(right_active) [self rightDrawerButton:nil];
    if(left_active) [self leftDrawerButton:nil];
    UIViewController* childController = [notif.userInfo objectForKey:@"childController"];
    if(!childController) return;
    [UIView setAnimationsEnabled:true];
    [self.navigationController pushViewController:childController animated:YES];
}

-(void)showHome:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"showHome"]) return;
    [UIView setAnimationsEnabled:YES];
    UIView* tabBar = self.view.superview.superview;
    CGFloat window_width = self.view.window.frame.size.width;
    CGFloat window_height = self.view.window.frame.size.height;
//    [self.nextView setFrame:CGRectMake(0, 0, window_width, window_height)];
    [UIView animateWithDuration:SIDE_DRAWER_ANIMATION_DURATION
         animations:^(void){
             [tabBar setFrame:CGRectMake(0, 0, window_width, window_height)];
//             [self.nextView setFrame:CGRectMake(window_width, 0, window_width, window_height)];
         }
         completion:^(BOOL completed){
             [UIView setAnimationsEnabled:NO];
//             [self.nextView setHidden:true];
         }
     ];
}


/* Should be optimized */
-(NSArray*)getFilteredFeed{
    NSMutableArray* feedToFilter = self.feed;
    if (self.active_category_id){
        feedToFilter = [self.categoryFeeds objectForKey:self.active_category_id];
    }
    NSIndexSet *indices = [feedToFilter indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        Feed* feedItem = (Feed*) obj;
        if(!showEvents && !showPhotos && !showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Photo"] && showPhotos) return true;
        if([feedItem.feedType isEqualToString:@"Video"] && showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Event"] && showEvents) return true;
        return false;
    }];
    return [feedToFilter objectsAtIndexes:indices];
}

-(void)getFeedAfter:(NSString*)feed_id{
    if(!getting_feed){
        getting_feed = true;
        if(!feed_id){
            if (!active_category_id){
                [[AppDelegate zazzApi] getFeed];
                return;
            }
            [[AppDelegate zazzApi] getFeedCategory:active_category_id];
            return;
        }
        if(!active_category_id){
            [[AppDelegate zazzApi] getFeedAfter:feed_id];
            return;
        }
        [[AppDelegate zazzApi] getFeedCategory:active_category_id after:feed_id];
        return;
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    NSLog(@"animation finished");
    [UIView setAnimationsEnabled:YES];
}


#pragma mark - Interface Builder Actions

-(IBAction)rightDrawerButton:(id)sender{
    if(left_active) [self leftDrawerButton:nil];//close left drawer first.
    CGFloat rightNavWidth =self.rightNav.frame.size.width;
    UIToolbar* tabBar = [[AppDelegate getAppDelegate] appTabBar].tabBar;
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:SIDE_DRAWER_ANIMATION_DURATION
             animations:^(void){
                 if(!right_active){ //open it
                     [self.rightNav setFrame:CGRectMake(CGRectGetWidth(self.view.window.frame) - rightNavWidth, 0, rightNavWidth, CGRectGetHeight(self.view.window.frame))];
                     [self.navFeedView setFrame:CGRectMake(-rightNavWidth,0, CGRectGetWidth(self.navFeedView.frame), CGRectGetHeight(self.navFeedView.frame))];
                     [tabBar setFrame:CGRectMake(-rightNavWidth, CGRectGetMinY(tabBar.frame),CGRectGetWidth(tabBar.frame),CGRectGetHeight(tabBar.frame))];
                     return;
                 }
                 //otherwise close it
                 [self resetSlidingViews];
             }
             completion:^(BOOL completed){
                 right_active = !right_active;
                 [UIView setAnimationsEnabled:NO];
             }
     ];
}
-(IBAction)leftDrawerButton:(id)sender{
    if(right_active) [self rightDrawerButton:nil]; //close right drawer first.
    CGFloat leftNavWidth =self.leftNav.frame.size.width;
    UIToolbar* tabBar = [[AppDelegate getAppDelegate] appTabBar].tabBar;
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:SIDE_DRAWER_ANIMATION_DURATION
         animations:^(void){
             if(!left_active){ //open it
                 [self.leftNav setFrame:CGRectMake(0, 0, leftNavWidth, self.view.window.frame.size.height)];
                 [self.navFeedView setFrame:CGRectMake(leftNavWidth,0, CGRectGetWidth(self.navFeedView.frame), CGRectGetHeight(self.navFeedView.frame))];
                 [tabBar setFrame:CGRectMake(leftNavWidth, CGRectGetMinY(tabBar.frame),CGRectGetWidth(tabBar.frame),CGRectGetHeight(tabBar.frame))];
                 return;
             }
             //otherwise close it
             [self resetSlidingViews];
         }
         completion:^(BOOL complete){
             left_active = !left_active;
             [UIView setAnimationsEnabled:NO];
         }
     ];
}
-(IBAction)expandFilterCell:(id)sender{
    filter_active = !filter_active;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [UIView setAnimationsEnabled:NO];
    }];
    [UIView setAnimationsEnabled:YES];
    [self.feedTableView beginUpdates];
    [self.feedTableView endUpdates];
    [CATransaction commit];
}
-(IBAction)toggleFilter:(id)sender{
    if (((UISwitch*)sender).tag == 1){  showVideos = !showVideos; }
    else if(((UISwitch*)sender).tag == 2){ showPhotos = !showPhotos; }
    else if(((UISwitch*)sender).tag == 3){ showEvents = !showEvents; }
    [self setFilteredFeed:[self getFilteredFeed]];
    [[self feedTableView] reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* source_feed = [self getFilteredFeed];
    return [source_feed count] + 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row == [self.getFilteredFeed count]) return;
    Feed* feedItem = [self.getFilteredFeed objectAtIndex:indexPath.row - 1];
    DetailViewItem* detailItem = [[DetailViewItem alloc] init];
    if([feedItem.feedType isEqualToString:FEED_PHOTO]){
        Photo* photo = (Photo*)[(NSMutableArray*)[feedItem content] objectAtIndex:0];
        [detailItem setPhoto:photo.image];
        [detailItem setDescription:photo.description];
        [detailItem setCategories:photo.categories];
        [detailItem setType:COMMENT_TYPE_PHOTO];
        [detailItem setItemId:photo.photoId];
        [detailItem setUser:photo.user];
        [detailItem setLikes:0];
    }else if([feedItem.feedType isEqualToString:FEED_POST]){
        Post* post = (Post*)[feedItem content];
        [detailItem setPhoto:nil];
        [detailItem setDescription:post.message];
        [detailItem setCategories:post.categories];
        [detailItem setType:COMMENT_TYPE_POST];
        [detailItem setItemId:post.postId];
        [detailItem setUser:post.fromUser];
        [detailItem setLikes:0];
    }else if([feedItem.feedType isEqualToString:FEED_EVENT]){
        Event* event = (Event*)[feedItem content];
        [detailItem setPhoto:nil];
        [detailItem setDescription:event.description];
        [detailItem setType:COMMENT_TYPE_EVENT];
        [detailItem setItemId:event.eventId];
        [detailItem setUser:event.user];
        [detailItem setLikes:0];
    }
    DetailViewController* detailViewController  = [[DetailViewController alloc] initWithDetailItem:detailItem];
    NSArray* keys  =    [NSArray arrayWithObjects: @"childController",  @"identifier", nil];
    NSArray* objects  = [NSArray arrayWithObjects: detailViewController, [NSString stringWithFormat:@"detailView-feed%@",feedItem.feedId], nil];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNextView" object:detailViewController userInfo:userInfo];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        if (filter_active) return 170;
        return 50;
    }
    if(indexPath.row == [self.filteredFeed count]+1){
        if (end_of_feed) return 10;
        return 57;
    }
    Feed *feedItem = [self.filteredFeed objectAtIndex:(indexPath.row - 1)];
    NSString *CellIdentifier = @"FeedTableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setFeed:feedItem];
    if([cell._neededPhotoIds count] > 0){
        for(NSString* photoId in cell._neededPhotoIds){
            [_indexPathsToReload setObject:indexPath forKey:photoId];
        }
    }
    return cell._height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        [(UIActivityIndicatorView*)[cell viewWithTag:5] stopAnimating];
        if(!end_of_feed){
            [(UIActivityIndicatorView*)[cell viewWithTag:5] startAnimating];
            NSMutableArray* feed = self.feed;
            if(active_category_id){
                feed = [categoryFeeds objectForKey:active_category_id];
            }
            Feed* lastFeed = (Feed*)feed.lastObject;
            NSString* last_feedId = nil;
            if (lastFeed){
                last_feedId = lastFeed.feedId;
            }
            [self getFeedAfter:last_feedId];
        }
        return cell;
    }
    
    NSString *CellIdentifier = @"FeedTableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Feed *feedItem = [self.filteredFeed objectAtIndex:(indexPath.row - 1)];
    [cell setFeed:feedItem];
//    NSLog(@"rendered:%@ - %fpx",cell._feed.feedId,cell._height);
    return cell;
}


#pragma mark - CFTabBarViewDelegate method
-(void)setViewHidden:(BOOL)hidden{
    [self.view.superview setHidden:hidden];
    if(hidden){
        if(right_active) [self rightDrawerButton:nil]; //close right drawer first.
        if(left_active) [self leftDrawerButton:nil]; //close right drawer first.
    }
}

-(void)gotPhotoImageNotification:(NSNotification *)notif{
    //only called when photo needs to be displayed and it hasn't been loaded yet.
    //Trigger this by filtering feed by photos...
    if(![notif.name isEqualToString:@"gotPhotoImage"]) return;
    Photo* photo = [notif.userInfo objectForKey:@"photo"];
    NSIndexPath* indexpath = [_indexPathsToReload objectForKey:photo.photoId];
    if(!indexpath )return;
//    [[self feedTableView] reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.feedTableView reloadData];
}

@end
