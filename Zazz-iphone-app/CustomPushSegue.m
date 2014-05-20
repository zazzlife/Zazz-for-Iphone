//
//  CustomPushSegue.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "CustomPushSegue.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"

@implementation CustomPushSegue

-(void)perform {
    
    UIViewController<ViewAnimationDelegate> *sourceViewController = self.sourceViewController;
    UIViewController<ViewAnimationDelegate> *destinationViewController = self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    // Store original centre point of the source view
    CGPoint pageCenter = sourceViewController.view.center;
    
    // set the new view off screen.
    destinationViewController.view.center = CGPointMake(pageCenter.x * 3, pageCenter.y);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{sourceViewController.view.center = CGPointMake(-pageCenter.x, pageCenter.y); } //slide left a screen length
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // set present VC
                         if([[destinationViewController class] conformsToProtocol:@protocol(ViewAnimationDelegate)]){
                             [destinationViewController viewDidFinishAnimation];
                         }
                     }];
}

@end