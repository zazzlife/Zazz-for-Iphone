//
//  ToolBarView.h
//  SecretTestApp
//
//  Created by Aaron Pang on 3/28/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolBarView : UIView

@property UILabel* _cityLabel;

- (void)setNumberOfComments:(NSInteger)comments;
- (void)setCategories:(NSMutableArray*)category_ids;
- (void)setLikes:(int)likes;

@end
