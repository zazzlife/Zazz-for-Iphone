//
//  TextPostViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FeedViewController.h"
#import "PhotoPicker.h"

@protocol delegated <NSObject>
@property id delegate;
@end

@interface CreateMessageViewController : UIViewController<MediaReceiver>


@property IBOutlet UIView* mainView;
@property IBOutlet UITextView* postField;
@property IBOutlet UIView* keyboardToolbar;
@property UIViewController<delegated>* helperViewController;
@property BOOL presentImagePickerOnShow;
@property ALAsset* mediaAsset;

- (IBAction)putPost:(UIButton *)sender;

@end
