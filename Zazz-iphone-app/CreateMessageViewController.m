//
//  TextPostViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "CreateMessageViewController.h"
#import "AppDelegate.h"
#import "UIView.h"
#import "PostViewController.h"

@implementation CreateMessageViewController

NSString* placeholder;
BOOL haveAsset;
UIViewController<delegated>* _helperViewController = nil;
UIView* tempHelper;


-(void)viewDidLoad{
    placeholder = @"Add caption";
    NSLog(@"createMessageLoaded");
    [self.postField setInputAccessoryView:self.keyboardToolbar];
}

-(void)setHelperViewController:(UIViewController*)helperViewController{
    _helperViewController = helperViewController;
}

-(void)viewDidAppear:(BOOL)animated{
    for(UIView* subview in self.view.subviews){
        if(subview.tag < 200)continue;
        subview.layer.cornerRadius = 5;
        subview.layer.masksToBounds = YES;
    }
    if(_helperViewController){
        [_helperViewController setDelegate:self];
        [self presentViewController:_helperViewController animated:false completion:^(void){}];
    }else{
        [self.keyboardToolbar setHidden:false];
        [self.postField becomeFirstResponder];
    }
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

-(void)setMediaAttachment:(NSArray*)media{
    [self.keyboardToolbar setHidden:false];
    [self.postField becomeFirstResponder];
    
    NSString* identifier = @"uploadImage";
    UIImageView* thumbView = (UIImageView*)[self.postField.superview subviewWithRestorationIdentifier:identifier];
    if (!media){
        if (thumbView){
            [self.postField setFrame:CGRectMake(CGRectGetMinX(self.postField.frame),
                                                CGRectGetMinY(self.postField.frame),
                                                CGRectGetWidth(self.postField.frame) + CGRectGetWidth(thumbView.frame) + 5,
                                                CGRectGetHeight(self.postField.frame))];
            [thumbView removeFromSuperview];
        }
        return ;
    }
    
    if(!thumbView){
        CGRect textFrame = self.postField.frame;
        thumbView = [[UIImageView alloc] init];
        [thumbView setRestorationIdentifier:identifier];
        [thumbView setFrame:CGRectMake(CGRectGetMaxX(textFrame) - CGRectGetHeight(textFrame)-5,
                                       CGRectGetMinY(textFrame),
                                       CGRectGetHeight(textFrame),
                                       CGRectGetHeight(textFrame))];
        [self.postField setFrame:CGRectMake(CGRectGetMinX(textFrame),
                                            CGRectGetMinY(textFrame),
                                            CGRectGetWidth(textFrame) - CGRectGetWidth(thumbView.frame) - 5,
                                            CGRectGetHeight(textFrame))];
        [self.postField.superview addSubview:thumbView];
    }
    UIImage* pic =[UIImage imageWithCGImage:((ALAsset *)[media objectAtIndex:0]).thumbnail];
    [thumbView setBackgroundColor:[UIColor blackColor]];
    [thumbView setImage:pic];
}

@end
