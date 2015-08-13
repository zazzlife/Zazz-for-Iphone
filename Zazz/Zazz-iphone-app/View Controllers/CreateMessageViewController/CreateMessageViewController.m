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
#import "HomeViewController.h"
#import "PhotoPicker.h"

@implementation CreateMessageViewController

@synthesize helperViewController;
@synthesize mediaAsset;

NSString* placeholder;
UIView* tempHelper;

-(CreateMessageViewController*)init{
    if(!self)self = [super init];
    [self setHelperViewController:nil];
    [self setMediaAsset:nil];
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
        [catStat setCategory_id:[NSString stringWithFormat:@"%lu",(long)category.tag]];
        NSString* catName = [catStat getIconName];
        UIImage* categoryImage = [UIImage imageNamed:catName withColor:[UIColor colorFromHexString:COLOR_ZAZZ_BLACK]];
        [(UIButton*)category setRestorationIdentifier:catName];
        [(UIButton*)category setImage:categoryImage forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(madePost:) name:@"madePost" object:nil];
    [self.keyboardToolbar removeFromSuperview];
    [self.postField setInputAccessoryView:self.keyboardToolbar];
}

id _activePicker = nil;
-(void)viewDidAppear:(BOOL)animated{
    _activePicker = nil;
    if(self.presentImagePickerOnShow){
        _activePicker = [[PhotoPicker alloc] initWithMediaReceiver:self];
        [_activePicker pickAssets];
        self.presentImagePickerOnShow = false;
        return;
    }
    for(UIView* subview in self.view.subviews){
        if(subview.tag < 200)continue;
        subview.layer.cornerRadius = 5;
        subview.layer.masksToBounds = YES;
    }
    [self.postField becomeFirstResponder];
}

- (IBAction)hideKeyboard:(UIBarButtonItem *)sender {
    [self.postField resignFirstResponder];
}

-(NSMutableArray*)getSelectedCatgoryIds{
    NSMutableArray* ids =[[NSMutableArray alloc] init];
    UIView* categoriesView = [self.view subviewWithRestorationIdentifier:@"categories"];
    for(UIView* category in categoriesView.subviews){
        if([category isKindOfClass:[UIButton class]] && [(UIButton*)category isSelected] ){
            [ids addObject:[NSString stringWithFormat:@"%ld",(long)category.tag]];
        }
    }
    return ids;
}

- (IBAction)putPost:(UIButton *)sender {
    NSMutableArray* categoryIds = [self getSelectedCatgoryIds];
    if(self.mediaAsset){
        CGImageRef cgImg = [[self.mediaAsset defaultRepresentation] fullResolutionImage];
        Photo* photo = [[Photo alloc] init];
        [photo setCategories:categoryIds];
        [photo setImage:[UIImage imageWithCGImage:cgImg]];
        [photo setDescription:self.postField.text];
        [[AppDelegate zazzApi] postPhoto:photo];
    }else{
        Post* post = [[Post alloc] init];
        [post setMessage:self.postField.text];
        if([[self.postField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]<=0){
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:@"Unable to post."
                                       message:@"Please supply a message before posting."
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
            
            [alertView show];
            return;
        }
        [post setCategories:categoryIds];
        [[AppDelegate zazzApi] postPost:post];
    }
    return;
}

-(void)tagUsers:(UIButton*)sender{
    
}
-(void)tagPlace:(UIButton*)sender{
    
}
-(void)shareUsers:(UIButton*)sender{
    
}

-(void)madePost:(NSNotification*)notif{
    Post* post = notif.object;
    if(!post) return;
    [self goBack:nil];
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
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
    [self setMediaAsset:[media objectAtIndex:0]];
    UIImage* pic =[UIImage imageWithCGImage:self.mediaAsset.thumbnail];
    [thumbView setBackgroundColor:[UIColor blackColor]];
    [thumbView setImage:pic];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender{
    [segue.destinationViewController setTag:sender.tag];
}

@end
