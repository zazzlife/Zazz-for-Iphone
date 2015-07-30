//
//  EmbedFeedViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableViewController.h"

@interface EmbedFeedViewController : UIStoryboardSegue

@end
@implementation EmbedFeedViewController

- (void)perform {
    
    UIViewController* src = (UIViewController*) self.sourceViewController;
    FeedTableViewController* dst = (FeedTableViewController*) self.destinationViewController;
    [dst embededWithFeedViewControllerSegue];
//    [src addChildViewController:dst];
//    [src.view addSubview:dst.view];
//    
    //This line uses FLKAutolayout library to setup constraints
}
@end
