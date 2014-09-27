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
bool simple_refresh = false; //don't append/prepend data. just refresh existing content.

@synthesize scrollDelegate;
@synthesize active_category_id;
@synthesize feed_user_id;
@synthesize categoryFeeds;
@synthesize filteredFeed;
@synthesize end_of_feed;
@synthesize showEvents;
@synthesize showPhotos;
@synthesize showVideos;
@synthesize showPosts;
@synthesize require_feed_user_id;


int const GET_ALL_FEED = 0;
int const GET_ALL_FEED_AFTER = 1;
int const GET_CAT_FEED = 2;
int const GET_CAT_FEED_AFTER = 3;
int const GET_ALL_MY_FEED = 4;
int const GET_ALL_MY_FEED_AFTER = 5;

NSMutableDictionary* _indexPathsToReload;

-(void)viewDidEmbed{
    prepend_feed = true;
    end_of_feed = false;
    
    _indexPathsToReload = [[NSMutableDictionary alloc] init];
    
    [self setActive_category_id:@""];
    [self setCategoryFeeds:[[NSMutableDictionary alloc] init]];
    [self.categoryFeeds setObject:[[NSMutableArray alloc] init] forKey:self.active_category_id];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzFeed:) name:@"gotFeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotPhotoImageNotification:) name:@"gotPhotoImage" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if([self scrollDelegate]){
        //this view is embeded and has a parent.
        [self doRefresh:self.refreshControl];
    }
}

#pragma mark - Table view data source
//#SECTIONS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray* newFilteredFeed = [self getActiveFeed];
    [self setFilteredFeed:newFilteredFeed];
    return 1;
}
//#ROWS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [self.filteredFeed count];
    if(end_of_feed || prepend_feed) return count;
    return count + 1;
}
//did-SELECT
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Feed* feedItem = [self.filteredFeed objectAtIndex:indexPath.row];
    DetailViewItem* detailItem = [[DetailViewItem alloc] init];
    if([feedItem.feedType isEqualToString:FEED_PHOTO]){
        Photo* photo = (Photo*)[(NSMutableArray*)[feedItem content] objectAtIndex:0];
        [detailItem setImage:photo.image];
        [detailItem setDescription:photo.description];
        [detailItem setCategories:photo.categories];
        [detailItem setType:COMMENT_TYPE_PHOTO];
        [detailItem setItemId:photo.photoId];
        [detailItem setUser:photo.user];
        [detailItem setLikes:0];
    }else if([feedItem.feedType isEqualToString:FEED_POST]){
        Post* post = (Post*)[feedItem content];
        [detailItem setImage:nil];
        [detailItem setDescription:post.message];
        [detailItem setCategories:post.categories];
        [detailItem setType:COMMENT_TYPE_POST];
        [detailItem setItemId:post.postId];
        [detailItem setUser:post.fromUser];
        [detailItem setLikes:0];
    }else if([feedItem.feedType isEqualToString:FEED_EVENT]){
        Event* event = (Event*)[feedItem content];
        [detailItem setImage:nil];
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
//HEIGHT
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
//CELL
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

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    if(scrollView.contentOffset.y){
//        [scrollView setScrollEnabled:true];
//        [scrollView setScrollsToTop:true];
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//        id<UIScrollViewDelegate> delegateScroll = self.scrollDelegate;
//        [delegateScroll scrollViewDidScroll:scrollView];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [(id<UIScrollViewDelegate>)self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}



-(void)getFeedAfter:(NSString*)feed_id{
    if(getting_feed) return;
    
    getting_feed = true;
    BOOL haveCategory =  !(!self.active_category_id || [self.active_category_id isEqualToString:@""]);
    
    if(feed_user_id && !feed_id){
        [[AppDelegate zazzApi] getUserFeed:feed_user_id];
        return;
    }
    if(feed_user_id){
        [[AppDelegate zazzApi] getUserFeed:feed_user_id after:feed_id];
        return;
    }
    if(haveCategory && !feed_id){
        [[AppDelegate zazzApi] getFeedCategory:self.active_category_id];
        return;
    }
    if(haveCategory){
        [[AppDelegate zazzApi] getFeedCategory:self.active_category_id after:feed_id];
        return;
    }
    if(feed_id){
        [[AppDelegate zazzApi] getFeedAfter:feed_id];
        return;
    }
    
    [[AppDelegate zazzApi] getFeed];
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
    
    [self.tableView reloadData];
}

-(void)gotZazzFeed:(NSNotification *)notif{
    if (![notif.name isEqualToString:@"gotFeed"]) return;
    if (self.require_feed_user_id && !self.feed_user_id) return;
    
    NSString* notif_feed_user_id = [NSString stringWithFormat:@"%@",[notif.userInfo objectForKey:@"user_id"]];
    NSString* self_feed_user_id = [NSString stringWithFormat:@"%@",feed_user_id];
    
    if(feed_user_id && ![self_feed_user_id isEqualToString:notif_feed_user_id])return;
    NSMutableArray* feed = [notif.userInfo objectForKey:@"feed"];
    NSString* category_ids = [notif.userInfo objectForKey:@"category_ids"];
    [self.refreshControl endRefreshing];
    if (!feed || ![category_ids isEqualToString:self.active_category_id]) return;
    
    getting_feed = false;
    
    if(prepend_feed){
        NSMutableArray* newFeedItems = [[NSMutableArray alloc] init];
        NSMutableArray* currentFeed = [self.categoryFeeds objectForKey:self.active_category_id];
        Feed* curTopFeedItem = (Feed*)[currentFeed firstObject];
        if(!curTopFeedItem){
            newFeedItems = feed;
        }
        else{
            for(Feed* newFeedItem in feed){
                if([[NSString stringWithFormat:@"%@",newFeedItem.feedId] isEqualToString:[NSString stringWithFormat:@"%@",curTopFeedItem.feedId]]){
                    break;
                }
                [newFeedItems addObject:newFeedItem];
            }
        }
        [newFeedItems addObjectsFromArray:currentFeed];
        [self.categoryFeeds removeObjectForKey:self.active_category_id];
        [self.categoryFeeds setObject:newFeedItems forKey:self.active_category_id];
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
    [self.tableView setDelegate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"feedDataSourceUpdated" object:nil];
    [self.tableView reloadData];
}

//Returns the active categories feed based on the selected filters.
-(NSArray*)getActiveFeed{
    NSMutableArray* activeFeed = [self.categoryFeeds objectForKey:self.active_category_id];
    if(![activeFeed count]) return activeFeed;
    NSIndexSet* activeIndexs = [activeFeed indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        Feed* feedItem = (Feed*) obj;
        if(!showPosts && !showEvents && !showPhotos && !showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Photo"] && showPhotos) return true;
        if([feedItem.feedType isEqualToString:@"Video"] && showVideos) return true;
        if([feedItem.feedType isEqualToString:@"Event"] && showEvents) return true;
        if([feedItem.feedType isEqualToString:@"Post"] && showPosts) return true;
        return false;
    }];
    return [activeFeed objectsAtIndexes:activeIndexs];
}

@end
