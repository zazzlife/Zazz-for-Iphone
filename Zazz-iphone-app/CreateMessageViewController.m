//
//  TextPostViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "CreateMessageViewController.h"
#import "AppDelegate.h"
#import "PostViewController.h"

@implementation CreateMessageViewController

NSString* placeholder;

-(void)viewDidLoad{
    placeholder = @"Add caption";
    [self.postField setInputAccessoryView:self.keyboardToolbar];
}

-(void)viewDidAppear:(BOOL)animated{
    for(UIView* subview in self.view.subviews){
        if(subview.tag < 200)continue;
        subview.layer.cornerRadius = 5;
        subview.layer.masksToBounds = YES;
    }
    [self.postField becomeFirstResponder];
}

- (IBAction)goBack:(UIButton *)sender {
    [(PostViewController*)self.parentViewController setViewHidden:true];
    [self.view endEditing:YES];
}
- (IBAction)hideKeyboard:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
}

-(IBAction)pressedCategory:(UIButton*)sender{
    NSString* identifier = sender.restorationIdentifier;
    if([identifier isEqualToString:@"Concert"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Drink_Special"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Hip_Hop_Music"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Turning_Up"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"House_Party"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Ladies_Free"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Live_Music_Mic"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"No_Cover"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Open_Bar"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Packed"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"Pre_Drink"]){
        NSLog(@"clicked: %@",identifier);
    }
    else if([identifier isEqualToString:@"House_Music"]){
        NSLog(@"clicked: %@",identifier);
    }
    return;
}

@end
