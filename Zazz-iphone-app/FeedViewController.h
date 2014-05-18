//
//  FeedTableViewController.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZazzApi.h"

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZazzFeedDelegate>

@property NSMutableArray* feed;

@property IBOutlet UITableView* feedTableView;

@end
