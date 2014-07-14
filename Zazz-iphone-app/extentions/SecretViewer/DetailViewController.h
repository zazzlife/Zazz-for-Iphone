//
//  RootViewController.h
//  SecretTestApp
//
//  Created by Aaron Pang on 3/28/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@interface DetailViewController: UIViewController

@property UIViewController* delegate;

-(id)initWithPhoto:(UIImage*)image andDescription:(NSString*)description andDelegate:(UIViewController*)delegateController;
-(id)initWithText:(NSString*)text andDelegate:(UIViewController*)controller;


@end
