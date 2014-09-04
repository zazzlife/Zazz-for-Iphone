//
//  FeedTableViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StickyTopScrollViewDelegate <NSObject>

@optional -(void)scrollViewToTopIfNeeded:(UIScrollView*)scrollView;

@end
@interface FeedTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property UIViewController<StickyTopScrollViewDelegate>* scrollDelegate;
@property NSMutableDictionary* categoryFeeds;
@property NSString* active_category_id;
@property NSString* feed_user_id;
@property NSArray* filteredFeed;

@property bool showPosts;
@property bool showPhotos;
@property bool showEvents;
@property bool showVideos;

@property BOOL end_of_feed;

-(IBAction)doRefresh:(id)sender;
-(void)initFeedViewController;
-(void)getFeedAfter:(NSString*)feed_id;
-(NSArray*)getActiveFeed;

@end