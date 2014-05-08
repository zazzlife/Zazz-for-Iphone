//
//  FeedTableViewCell.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *UserImage;
@property (nonatomic, strong) IBOutlet UILabel *UserName;
@property (nonatomic, strong) IBOutlet UILabel *TimeStamp;

@end
