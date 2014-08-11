//
//  FeedTableViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property UIViewController* scrollDelegate;
@property NSMutableDictionary* categoryFeeds;
@property NSString* active_category_id;
@property NSArray* filteredFeed;

@property bool showPhotos;
@property bool showEvents;
@property bool showVideos;

@property BOOL end_of_feed;

-(IBAction)doRefresh:(id)sender;
-(void)getFeedAfter:(NSString*)feed_id;

@end

@protocol ScrollViewDelegate <NSObject>

@optional
-(void)scrollViewDidScroll:(UIScrollView*)scrollView;

@end
