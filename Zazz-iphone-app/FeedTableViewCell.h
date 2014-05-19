//
//  FeedTableViewCell.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface FeedTableViewCell : UITableViewCell

@property IBOutlet UITableView* tableView;
@property IBOutlet UIImageView* userImage;
@property IBOutlet UIView* content;
@property IBOutlet UILabel* timestamp;
@property IBOutlet UILabel* username;
@property CGFloat needed_height;

-(void)setFeed:(Feed*)feed;

@end
