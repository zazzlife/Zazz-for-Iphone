//
//  CustomPopSegue.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/15/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "CustomPopSegue.h"
#import "AppDelegate.h"

@implementation CustomPopSegue

-(void)perform {
    
    UIViewController<ViewAnimationDelegate> *sourceViewController = self.sourceViewController;
    UIViewController<ViewAnimationDelegate> *destinationViewController = self.destinationViewController;
    
    [sourceViewController resignFirstResponder];
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    // Store original centre point of the source view
    CGPoint pageCenter = sourceViewController.view.center;
    
    // set the new view off screen.
    destinationViewController.view.center = CGPointMake(-pageCenter.x, pageCenter.y);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{sourceViewController.view.center = CGPointMake(pageCenter.x * 3, pageCenter.y); } //slide right a screen length
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController.navigationController popViewControllerAnimated:NO]; // set present VC
                         if([[destinationViewController class] conformsToProtocol:@protocol(ViewAnimationDelegate)]){
                             [destinationViewController viewDidFinishAnimation];
                         }
                     }];
}

@end
