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
    
    [self setFeed:[[NSMutableArray alloc] init]];
}

bool end_of_feed = false;
-(void)gotZazzFeed:(NSMutableArray*)feed{
    [[AppDelegate getAppDelegate] removeZazzBackgroundLogo];
    int old_count = self.feed.count;
    if(self.feed.count == 0){
        [self setFeed:feed];
    }else{
        [self.feed addObjectsFromArray:feed];
    }
    if(self.feed.count <= old_count){
        end_of_feed = true;
    }
    [[self feedTableView] reloadData];
}

BOOL _loaded = false;
-(void)viewWillAppear:(BOOL)animated{
    if (!_loaded){
        _loaded = YES;
        [[[AppDelegate getAppDelegate] zazzAPI] getMyFeedDelegate:self];
    }
}


-(void)doSwipes:(UIGestureRecognizer *) sender {
    [self leftDrawerButton:nil];
}

-(IBAction)leftDrawerButton:(id)sender {
    if (!left_active){
        [self.tabBarController.view.superview addSubview:self.sideNav];
    }
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
    if(end_of_feed) return [[self feed] count] + 1;
    return [[self feed] count] + 2;
}

bool getting_height = false;
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    getting_height = true;
    FeedTableViewCell* cell = (FeedTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    getting_height = false;
    if(indexPath.row == 0) return 55;
    if(indexPath.row == [self.feed count]+1){return 57;}
    return cell.needed_height;
}



int call_stack = 0;
int lastSeen = 0;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"CFR: %d, %d, %d",indexPath.row, getting_height, self.feed.count);
    lastSeen = indexPath.row;
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
    if(indexPath.row == [self.feed count]+1){
        NSString* CellIdentifier = @"feedMoreLoader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if(!getting_height && self.feed.count > 0){
            NSString* last_feedId = (NSString*)[(Feed*)[self.feed objectAtIndex:indexPath.row-2] feedId];
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
    Feed *feedItem = [[self feed] objectAtIndex:[indexPath row]-1];
    [cell setFeed:feedItem];
    return cell;
}

@end
