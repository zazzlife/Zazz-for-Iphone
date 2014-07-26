//
//  TextPostViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedViewController.h"

@interface CreateMessageViewController : UIViewController<ChildViewController>

@property IBOutlet UIView* mainView;
@property IBOutlet UIView* helperView;
@property IBOutlet UITextView* postField;
@property IBOutlet UIView* keyboardToolbar;
@property (nonatomic) UIViewController* parentViewController;

@end
