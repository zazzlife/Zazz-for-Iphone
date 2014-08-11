        //
//  FeedTableViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedTableViewCell.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Feed.h"
#import "UIView.h"
#import "UIColor.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

bool prepend_feed = false; //used when refreshing the feed to clear all seen feeds.
bool getting_feed = false; //true when a getZazzFeed call is active.
bool simple_refresh = true; //don't append/prepend data. just refresh existing content.
@synthesize scrollDelegate;
@synthesize active_category_id;
@synthesize categoryFeeds;
@synthesize filteredFeed;
@synthesize end_of_feed;
@synthesize showEvents;
@synthesize showPhotos;
@synthesize showVideos;

NSMutableDictionary* _indexPathsToReload;


- (void)viewDidLoad
{
    [super viewDidLoad];
    prepend_feed = true;
    end_of_feed = false;
    showEvents = false;
    showPhotos = false;
    showVideos = false;
    
    _indexPathsToReload = [[NSMutableDictionary alloc] init];
    
    [self setActive_category_id:@""];
    [self setCategoryFeeds:[[NSMutableDictionary alloc] init]];
    [self.categoryFeeds setObject:[[NSMutableArray alloc] init] forKey:self.active_category_id];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzFeed:) name:@"gotFeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotPhotoImageNotification:) name:@"gotPhotoImage" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self doRefresh:self.refreshControl];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray* newFilteredFeed = [self getActiveFeed];
    [self setFilteredFeed:newFilteredFeed];
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(prepend_feed || end_of_feed) return [self.filteredFeed count];
    return [self.filteredFeed count] + 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Feed* feedItem = [self.filteredFeed objectAtIndex:indexPath.row];
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
    if(indexPath.row == [self.filteredFeed count]){
        return 44;
    }
    Feed *feedItem = [self.filteredFeed objectAtIndex:(indexPath.row)];
    NSString *CellIdentifier = @"FeedTableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setTableView:tableView];
    [cell setFeed:feedItem];
    if([cell._neededPhotoIds count] > 0){
        for(NSString* photoId in cell._neededPhotoIds){
            [_indexPathsToReload setObject:indexPath forKey:photoId];
        }
    }
    return cell._height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.filteredFeed count]){
        NSString *CellIdentifier = @"FeedFetchMoreCell";
        FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSString* feedId = nil;
        Feed* lastFeed = (Feed*)[[self.categoryFeeds objectForKey:self.active_category_id] lastObject];
        if(lastFeed){
            feedId = lastFeed.feedId;
        }
        [self getFeedAfter:feedId];
        UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[cell.contentView subviewWithRestorationIdentifier:@"fetchMoreSpinner"];
        [spinner startAnimating];
        return cell;
    }
    NSString *CellIdentifier = @"FeedTableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setTableView:tableView];
    Feed* feedItem = [self.filteredFeed objectAtIndex:(indexPath.row)];
    [cell setFeed:feedItem];
    return cell;
}



-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(decelerate)return;
    if([self.scrollDelegate respondsToSelector:@selector(scrollViewToTopIfNeeded:)]){
        [self.scrollDelegate scrollViewToTopIfNeeded:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.scrollDelegate respondsToSelector:@selector(scrollViewToTopIfNeeded:)]){
        [self.scrollDelegate scrollViewToTopIfNeeded:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [(id<UIScrollViewDelegate>)self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

-(void)getFeedAfter:(NSString*)feed_id{
    if(!getting_feed){
        getting_feed = true;
        if(!feed_id){
            if ([self.active_category_id isEqualToString:@""]){
                [[AppDelegate zazzApi] getFeed];
                return;
            }
            [[AppDelegate zazzApi] getFeedCategory:active_category_id];
            return;
        }
        if([self.active_category_id isEqualToString:@""]){
            [[AppDelegate zazzApi] getFeedAfter:feed_id];
            return;
        }
        [[AppDelegate zazzApi] getFeedCategory:active_category_id after:feed_id];
        return;
    }
}

- (IBAction)doRefresh:(id)sender {
    prepend_feed = true;
    [self.refreshControl beginRefreshing];
    [self getFeedAfter:NULL];
}

-(void)gotPhotoImageNotification:(NSNotification *)notif{
    if(![notif.name isEqualToString:@"gotPhotoImage"]) return;
    Photo* photo = [notif.userInfo objectForKey:@"photo"];
    NSIndexPath* indexpath = [_indexPathsToReload objectForKey:photo.photoId];
    if(!indexpath )return;
    simple_refresh = true;
    [self.tableView reloadData];
    simple_refresh = false;
}

-(void)gotZazzFeed:(NSNotification *)notif{
    if (![notif.name isEqualToString:@"gotFeed"]) return;
    NSMutableArray* feed = [notif.userInfo objectForKey:@"feed"];
    NSString* category_ids = [notif.userInfo objectForKey:@"category_ids"];
    [self.refreshControl endRefreshing];
    if (!feed || ![category_ids isEqualToString:self.active_category_id]) return;
    
    getting_feed = false;
    
    if(prepend_feed){
        NSMutableArray* feedItemsToPrepend = [[NSMutableArray alloc] init];
        NSMutableArray* currentFeed = [self.categoryFeeds objectForKey:self.active_category_id];
        Feed* curTopFeedItem = (Feed*)[currentFeed firstObject];
        if(!curTopFeedItem){
            feedItemsToPrepend = feed;
        }
        else{
            for(Feed* newFeedItem in feed){
                if(newFeedItem.feedId == curTopFeedItem.feedId) break;
                [feedItemsToPrepend addObject:newFeedItem];
            }
        }
        [feedItemsToPrepend addObjectsFromArray:currentFeed];
        [self.categoryFeeds setObject:feedItemsToPrepend forKey:self.active_category_id];
        prepend_feed = false;
    }else if([feed count] <= 0){
        self.end_of_feed = true;
        [self.tableView reloadData];
        return;
    }
    else if(!simple_refresh){
        NSMutableArray* catFeed = [self.categoryFeeds objectForKey:self.active_category_id];
        if(!catFeed){
            [self.categoryFeeds setObject:[[NSMutableArray alloc] init] forKey:self.active_category_id];
            catFeed = [self.categoryFeeds objectForKey:self.active_category_id];
        }
        [catFeed addObjectsFromArray:feed];
    }
    [self.tableView reloadData];
    return;
}

//Returns the active categories feed based on the selected filters.
-(NSArray*)getActiveFeed{
    NSMutableArray* activeFeed = [self.categoryFeeds objectForKey:self.active_category_id];
    if(![activeFeed count]) return activeFeed;
    NSIndexSet* activeIndexs = [activeFeed indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        Feed* feedItem = (Feed*) obj;
        if(!showEvents && !showPhotos && !showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Photo"] && showPhotos) return true;
        if([feedItem.feedType isEqualToString:@"Video"] && showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Event"] && showEvents) return true;
        return false;
    }];
    return [activeFeed objectsAtIndexes:activeIndexs];
}

@end
