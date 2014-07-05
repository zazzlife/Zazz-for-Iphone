//
//  TextPostViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedViewController.h"

@interface TextPostViewController : UIViewController<ChildViewController>

@property IBOutlet UITextView* postField;
@property IBOutlet UIView* keyboardToolbar;
@property (nonatomic) UIViewController* parentViewController;

@end
