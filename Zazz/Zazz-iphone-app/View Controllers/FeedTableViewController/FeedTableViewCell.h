//
//  FeedTableViewCell.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

#define CELL_HEIGHT 150 //default height of a cell. (including outer border)
#define CELL_HEADER_HEIGHT 60 // height of user thumbnail area.
#define CELL_CONTENT_PADDING_BOTTOM 10 //white padding bellow photo.
#define CELL_TEXT_CONTENT_PADDING 10 //top andbottom padding for text content.
#define CELL_PADDING_TOP 10 //black outer edge top/bottom.
#define CELL_PADDING_SIDES 5 //black outer edge/sides.

@interface FeedTableViewCell : UITableViewCell

@property IBOutlet UITableView* tableView;
@property IBOutlet FwiImage *userImage;
@property IBOutlet UIView* feedCellBackgroundView;
@property IBOutlet FwiImage* feedCellContentView;
@property IBOutlet UILabel* timestamp;
@property IBOutlet UILabel* username;
@property IBOutlet UIButton* profileButton;
@property Feed* _feed;
@property float _height;
@property NSMutableArray* _neededPhotoIds;

-(void)setFeed:(Feed *)feed;
-(CGRect)cellBackgroundFrame;

- (void)visualizeCellWithUserImage:(NSURL *)imageUrl;
- (void)visualizeCellWithContent:(NSURL *)imageUrl;

@end
