//
//  RootViewController.h
//  SecretTestApp
//
//  Created by Aaron Pang on 3/28/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "DetailViewItem.h"

@interface DetailViewController: UIViewController

-(id)initWithDetailItem:(DetailViewItem*)detailItem;

@end
