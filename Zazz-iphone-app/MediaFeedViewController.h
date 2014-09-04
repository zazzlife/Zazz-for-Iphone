//
//  MediaFeedViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/31/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableViewController.h"

@interface MediaFeedViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property UIViewController<StickyTopScrollViewDelegate>* scrollDelegate;
@property FeedTableViewController* feedTableViewController;

-(void)viewDidEmbed;

@end
