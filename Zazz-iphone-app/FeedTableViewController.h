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
@property NSArray* filteredFeed;
@property NSString* feed_user_id;

@property bool end_of_feed;
@property bool require_feed_user_id;

@property bool showPosts;
@property bool showPhotos;
@property bool showEvents;
@property bool showVideos;

-(IBAction)doRefresh:(id)sender;
-(void)viewDidEmbed;
-(void)getFeedAfter:(NSString*)feed_id;
-(NSArray*)getActiveFeed;

@end