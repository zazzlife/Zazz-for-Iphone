//
//  TextPostViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FeedViewController.h"

@protocol delegated <NSObject>

@property id delegate;

@end

@protocol MediaReceiver <NSObject>

@optional
-(void)setMediaAttachment:(id)media;

@end

@interface CreateMessageViewController : UIViewController<ChildViewController,MediaReceiver>


@property IBOutlet UIView* mainView;
@property IBOutlet UITextView* postField;
@property IBOutlet UIView* keyboardToolbar;
@property (nonatomic) UIViewController* parentViewController;

-(void)setHelperViewController:(UIViewController *)helperViewController;

@end
