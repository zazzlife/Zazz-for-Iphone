        //
//  FeedTableViewController.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedTableViewCell.h"
#import "CFTabBarController.h"
#import "DetailViewController.h"
#import "Feed.h"
#import "Photo.h"
#import "AppDelegate.h"
#import "UIImage.h"
#import "UIView.h"
#import "UIColor.h"

@interface HomeViewController ()

@property NSString* active_category_id;

@end

@implementation HomeViewController

@synthesize swipe_left;
@synthesize swipe_right;

bool left_active = false; // used by leftNav to indicate if it's open or not.
bool right_active = false; // used by leftNav to indicate if it's open or not.
bool filter_active = false; // true if filter is expanded.

float NAV_BAR_HEIGHT = 56;
float FILTER_VIEW_OPEN_HEIGHT = 165;
float FILTER_VIEW_CLOSED_HEIGHT = 50;
float SIDE_DRAWER_ANIMATION_DURATION = .3;
float FILTER_VIEW_PADDING = 7;

/*
 The view has a sense of self and
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextView:) name:@"showNextView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHome:) name:@"showHome" object:nil];
    
    swipe_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipe_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipe_left.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe_right.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.centerScrollView setScrollsToTop:false];
    [self.centerScrollView setAlwaysBounceVertical:false];
    
    [self.view addGestureRecognizer:swipe_left];
    [self.view addGestureRecognizer:swipe_right];
}

-(void)viewWillAppear:(BOOL)animated{
    [self resetSlidingViews];
    [self scrollViewDidScroll:self.feedTableViewController.tableView];
    [self.filterView.layer setCornerRadius:5];
    [self.filterView setClipsToBounds:true];
}

-(void)resetSlidingViews{
    UIToolbar* tabBar = [[[AppDelegate getAppDelegate] appTabBar] tabBar];
    CGFloat tabBarHeight = tabBar.frame.size.height;
    [self.leftNav setFrame:CGRectMake(-CGRectGetWidth(self.leftNav.frame), 0, CGRectGetWidth(self.leftNav.frame), CGRectGetHeight(self.view.window.frame))];
    CGRect windowFrame = [AppDelegate getAppDelegate].window.frame;
    CGRect centerScrollFrame = windowFrame;
    centerScrollFrame.size.height = centerScrollFrame.size.height - tabBar.frame.size.height;
    [self.centerScrollView setFrame:centerScrollFrame];
    [self.rightNav setFrame:CGRectMake(CGRectGetMaxX(self.centerScrollView.frame), 0, CGRectGetWidth(self.rightNav.frame), CGRectGetHeight(self.view.window.frame))];
    [tabBar setFrame:CGRectMake(0, CGRectGetMaxY(self.centerScrollView.frame),CGRectGetWidth(tabBar.frame),tabBarHeight)];

    //they were hidden because the push animation looked weird when they are visible from the start.
    [self.rightNav setHidden:false];
    [self.leftNav setHidden:false];
}

-(void)didSwipeLeft:(UIGestureRecognizer *) recognizer{
    if(right_active) return;
    if(left_active){
        [self leftDrawerButton:nil];
        return;
    }
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
    [self.feedTableViewController setEnd_of_feed:false];
    NSString* active_category_id = self.feedTableViewController.active_category_id;
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
    [self.feedTableViewController setActive_category_id:active_category_id];
    [self.feedTableViewController.tableView reloadData];
    return retVal;
}

-(void)showNextView:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"showNextView"]) return;
    if(right_active) [self rightDrawerButton:nil];
    if(left_active) [self leftDrawerButton:nil];
    UIViewController* childController = [notif.userInfo objectForKey:@"childController"];
    if(!childController) return;
    [self.navigationController pushViewController:childController animated:YES];
}

-(void)showHome:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"showHome"]) return;
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
//             [self.nextView setHidden:true];
         }
     ];
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
                     [self.centerScrollView setFrame:CGRectMake(-rightNavWidth,0, CGRectGetWidth(self.centerScrollView.frame), CGRectGetHeight(self.view.frame))];
                     [tabBar setFrame:CGRectMake(-rightNavWidth, CGRectGetMinY(tabBar.frame),CGRectGetWidth(tabBar.frame),CGRectGetHeight(tabBar.frame))];
                     return;
                 }
                 //otherwise close it
                 [self resetSlidingViews];
             }
             completion:^(BOOL completed){
                 right_active = !right_active;
//                 [UIView setAnimationsEnabled:NO];
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
                 [self.centerScrollView setFrame:CGRectMake(leftNavWidth,0, CGRectGetWidth(self.centerScrollView.frame), CGRectGetHeight(self.view.frame))];
                 [tabBar setFrame:CGRectMake(leftNavWidth, CGRectGetMinY(tabBar.frame),CGRectGetWidth(tabBar.frame),CGRectGetHeight(tabBar.frame))];
                 return;
             }
             //otherwise close it
             [self resetSlidingViews];
         }
         completion:^(BOOL complete){
             left_active = !left_active;
//             [UIView setAnimationsEnabled:NO];
         }
     ];
}

-(IBAction)expandFilterCell:(id)sender{
    [UIView animateWithDuration:SIDE_DRAWER_ANIMATION_DURATION
         animations:^(void){
             float filter_height = FILTER_VIEW_CLOSED_HEIGHT;
             if(filter_active){
                 filter_height = FILTER_VIEW_OPEN_HEIGHT;
             }
             [self.filterView setFrame:CGRectMake(CGRectGetMinX(self.filterView.frame), CGRectGetMinY(self.filterView.frame), CGRectGetWidth(self.filterView.frame), filter_height)];
             [self.feedTableViewContainer setFrame:CGRectMake(CGRectGetMinX(self.feedTableViewContainer.frame), CGRectGetMaxY(self.filterView.frame), CGRectGetWidth(self.feedTableViewContainer.frame), CGRectGetHeight(self.feedTableViewContainer.frame))];
         }
         completion:^(BOOL completed){
             filter_active = !filter_active;
         }
     ];
    
}

-(IBAction)toggleFilter:(id)sender{
    if (((UISwitch*)sender).tag == 1){
        self.feedTableViewController.showVideos = !self.feedTableViewController.showVideos;
    }else if(((UISwitch*)sender).tag == 2){
        self.feedTableViewController.showPhotos = !self.feedTableViewController.showPhotos;
    }else if(((UISwitch*)sender).tag == 3){
        self.feedTableViewController.showEvents = !self.feedTableViewController.showEvents;
    }
    [self.feedTableViewController.tableView reloadData];
}


#pragma mark - CFTabBarViewDelegate method
-(void)setViewHidden:(BOOL)hidden{
    [self.view.superview setHidden:hidden];
    if(hidden){
        if(right_active) [self rightDrawerButton:nil]; //close right drawer first.
        if(left_active) [self leftDrawerButton:nil]; //close right drawer first.
    }
}



-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    float filter_view_height = self.filterView.frame.size.height;
    float delta = scrollView.contentOffset.y;
    NSLog(@"delta:%f",delta);
    if(delta <= 0){
        [self.centerScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else if(delta < CGRectGetMaxY(self.filterView.frame)){
        [self.centerScrollView setContentOffset:CGPointMake(0, delta)];
    }
    else if (delta >= CGRectGetMaxY(self.filterView.frame)){
        [self.centerScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(self.filterView.frame))];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if(![segue.identifier isEqualToString:@"embedFeedViewController"]) return;
    FeedTableViewController* feedController = (FeedTableViewController*)segue.destinationViewController;
    [self setFeedTableViewController:feedController];
    [feedController setScrollDelegate:self];
}

@end
