//
//  SecondViewController.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 4/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

{
    IBOutlet UIButton *GoToFeed2;
}

-(IBAction)StartFeed2:(id)sender;
-(void) GetFeed;

@end
