//
//  FirstViewController.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 4/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

{
    IBOutlet UIButton *GoToFeed1;
}

// Not sure this is necessary but I threw it in for now..

-(IBAction)StartFeed1:(id)sender;
-(void) GetFeed;


@end
