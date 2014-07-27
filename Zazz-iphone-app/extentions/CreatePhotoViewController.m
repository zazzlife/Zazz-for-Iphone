
/*
 CTMasterViewController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */
 

#import "CTAssetsPickerController.h"
#import "CTAssetsPageViewController.h"
#import "CreatePhotoViewController.h"
#import "FeedViewController.h"
#import "CreateMessageViewController.h"


@interface CreatePhotoViewController ()
<CTAssetsPickerControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIPopoverController *popover;

@end



@implementation CreatePhotoViewController

@synthesize delegate;
int MAX_NUMBER_OF_ASSETS = 1;
BOOL _canceled = false;

-(CreatePhotoViewController*)init{
    if(!self)self = [super init];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)viewDidLoad{
    UIBarButtonItem *clearButton = 
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(clearAssets:)];
    
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Pick", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(pickAssets:)];
    _canceled = false;
    
}

-(void)viewDidAppear:(BOOL)animated{
    if(!self.assets && !_canceled) return [self pickAssets:nil];
    if([self.delegate respondsToSelector:@selector(setMediaAttachment:)]){
        id assets = nil;
        if(!_canceled) assets = self.assets;
        [self.delegate setMediaAttachment:assets];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)clearAssets:(id)sender
{
    if (self.assets)
    {
        self.assets = nil;
//        [self.tableView reloadData];
    }
}

- (void)pickAssets:(id)sender
{
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];

    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allAssets];
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    [picker.view setBackgroundColor:[UIColor darkGrayColor]];
    
    // iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.popover.delegate = self;
        
        [self.popover presentPopoverFromBarButtonItem:sender
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    }
    else
    {
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - Popover Controller Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}


#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (self.popover != nil)
        [self.popover dismissPopoverAnimated:YES];
//    else
//        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    [self viewDidAppear:false];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count+1 > MAX_NUMBER_OF_ASSETS)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Please select no more than 1 asset"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Your asset has not yet been downloaded to your device"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count+1 <= MAX_NUMBER_OF_ASSETS && asset.defaultRepresentation != nil);
}

-(void)assetsPickerControllerDidCancel:(id)sender{
    _canceled = true;
    [self viewDidAppear:false];
}

@end
