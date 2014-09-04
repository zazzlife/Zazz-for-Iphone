//
//  MediaFeedViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/31/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "MediaFeedViewController.h"
#import "UIView.h"
#import "Feed.h"
#import "Photo.h"
#import "Comment.h"
#import "DetailViewController.h"
#import "DetailViewItem.h"

@implementation MediaFeedViewController

-(void)viewDidEmbed{
    NSLog(@"embeded mediaFeedViewController");
    [self.collectionView setScrollEnabled:true];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedDataSourceUpdated:) name:@"feedDataSourceUpdated" object:nil];
}

-(void)feedDataSourceUpdated:(NSNotification*)notif{
    if(![notif.name isEqualToString:@"feedDataSourceUpdated"]) return;
    if(![self.view.superview isHidden])
        [self.collectionView reloadData];
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



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    int count = [[self.feedTableViewController getActiveFeed] count];
    if(self.feedTableViewController.end_of_feed)
        return count;
    return count + 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* dataSource = (NSMutableArray*)[self.feedTableViewController getActiveFeed];
    if(!self.feedTableViewController.end_of_feed && indexPath.row >= [dataSource count]) return;
    Feed* feedItem = [dataSource objectAtIndex:indexPath.row];
    Photo* photo = (Photo*)[(NSMutableArray*)feedItem.content objectAtIndex:0];
    
    DetailViewItem* detailItem = [[DetailViewItem alloc]init];
    [detailItem setImage:photo.image];
    [detailItem setType:COMMENT_TYPE_PHOTO];
    [detailItem setItemId:photo.photoId];
    [detailItem setComments:feedItem.comments];
    [detailItem setDescription:photo.description];
    [detailItem setUser:feedItem.user];
    [detailItem setLikes:0];
    [detailItem setCategories:photo.categories];
    DetailViewController* detailView = [[DetailViewController alloc] initWithDetailItem:detailItem];
    
    NSArray* keys  =    [NSArray arrayWithObjects:
                         @"childController",
                         @"identifier",
                         nil];
    NSArray* objects  = [NSArray arrayWithObjects:
                         detailView,
                         [NSString stringWithFormat:@"detailView-tag%@",photo.photoId],
                         nil];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNextView" object:nil userInfo:userInfo];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* dataSource = (NSMutableArray*)[self.feedTableViewController getActiveFeed];
    int row = indexPath.row;
    if(!self.feedTableViewController.end_of_feed && indexPath.row >= [dataSource count]){
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"collectionSpinnerCell" forIndexPath:indexPath];
        UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[cell subviewWithRestorationIdentifier:@"spinnerView"];
        [spinner startAnimating];
        NSString* feedId = nil;
        Feed* lastFeed = (Feed*)[[self.feedTableViewController.categoryFeeds objectForKey:self.feedTableViewController.active_category_id] lastObject];
        if(lastFeed){
            feedId = lastFeed.feedId;
        }
        [self.feedTableViewController getFeedAfter:feedId];
        return cell;
    }
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    UIImageView* imageView = (UIImageView*)[cell subviewWithRestorationIdentifier:@"mediaImage"];
    
    Feed* feedItem = [dataSource objectAtIndex:indexPath.row];
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = self.view.window.frame.size.width/3;
    cellFrame.size.width = cellFrame.size.height;
    [cell setFrame:cellFrame];
    Photo* photo = (Photo*)[(NSMutableArray*)feedItem.content objectAtIndex:0];
    [imageView setImage:photo.image];
    
    return cell;
}

// the user tapped a collection item, load and set the image on the detail view controller
//

@end
