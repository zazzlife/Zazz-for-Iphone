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
#import "UIColor.h"
#import "UIImage.h"
#import "UIView.h"
#import "CategoryStat.h"
#import "PostViewController.h"

@implementation CreateMessageViewController

@synthesize helperViewController;

NSString* placeholder;
BOOL haveAsset;
UIView* tempHelper;

-(CreateMessageViewController*)init{
    if(!self)self = [super init];
    [self setHelperViewController:nil];
    return self;
}

-(void)viewDidLoad{
    placeholder = @"Add caption";
    UIView* categoriesView = [self.view subviewWithRestorationIdentifier:@"categories"];
    for(UIView* category in categoriesView.subviews){
        if(![category isKindOfClass:[UIButton class]])
            continue;
        UIButton* category;
        CategoryStat* catStat = [[CategoryStat alloc] init];
        [catStat setCategory_id:[NSString stringWithFormat:@"%lu",category.tag]];
        NSString* catName = [catStat getIconName];
        UIImage* categoryImage = [UIImage imageNamed:catName withColor:[UIColor colorFromHexString:COLOR_ZAZZ_BLACK]];
        [(UIButton*)category setRestorationIdentifier:catName];
        [(UIButton*)category setImage:categoryImage forState:UIControlStateNormal];
    }
    [self.postField setInputAccessoryView:self.keyboardToolbar];
}

-(NSMutableArray*)getSelectedCatgoryIds{
    NSMutableArray* ids =[[NSMutableArray alloc] init];
    UIView* categoriesView = [self.view subviewWithRestorationIdentifier:@"categories"];
    for(UIView* category in categoriesView.subviews){
        if([category isKindOfClass:[UIButton class]] && [(UIButton*)category isSelected] ){
            [ids addObject:[NSString stringWithFormat:@"%ld",category.tag]];
        }
    }
    return ids;
}

- (IBAction)putPost:(UIButton *)sender {
    NSMutableArray* categoryIds = [self getSelectedCatgoryIds];
    //CREATE ZAZZ API ACTION AND HOOK IT UP!
    NSLog(@"%@",categoryIds);
}

-(void)viewDidAppear:(BOOL)animated{
    for(UIView* subview in self.view.subviews){
        if(subview.tag < 200)continue;
        subview.layer.cornerRadius = 5;
        subview.layer.masksToBounds = YES;
    }
    if(self.helperViewController){
        [self.helperViewController setDelegate:self];
        [self presentViewController:self.helperViewController animated:false completion:^(void){}];
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
    [sender setSelected:!sender.selected];
    NSString* identifier = sender.restorationIdentifier;
    UILabel* categoryLabel = (UILabel*)[sender.superview subviewWithRestorationIdentifier:[NSString stringWithFormat:@"%@_label",identifier]];
    UIColor* selColor = [UIColor colorFromHexString:COLOR_ZAZZ_BLACK];
    if(sender.isSelected){
        selColor = [UIColor colorFromHexString:COLOR_ZAZZ_YELLOW];
    }
    [sender setImage:[UIImage imageNamed:identifier withColor:selColor] forState:UIControlStateNormal];
    [categoryLabel setTextColor:selColor];
    return;
}

//Called by Create<Media>ViewControllers.
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
