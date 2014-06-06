//
//  CHViewController.m
//  TumblrMenu
//
//  Created by HangChen on 12/9/13.
//  Copyright (c) 2013 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "PostViewController.h"
#import "CHTumblrMenuView.h"
#import "AppDelegate.h"

@implementation PostViewController

const int ACTION_POST = 0;
const int ACTION_PHOTO = 1;
const int ACTION_VIDEO = 2;

@synthesize menuView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block PostViewController* blockSafeSelf = self;
    
    self.menuView = [[CHTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"" andIcon:[UIImage imageNamed:@"post_type_bubble_text.png"] andSelectedBlock:^{
        [blockSafeSelf startAction:ACTION_POST];
    }];
    [menuView addMenuItemWithTitle:@"" andIcon:[UIImage imageNamed:@"post_type_bubble_photo.png"] andSelectedBlock:^{
        [blockSafeSelf  startAction:ACTION_PHOTO];
    }];
    [menuView addMenuItemWithTitle:@"" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
        [blockSafeSelf   startAction:ACTION_VIDEO];
    }];
}

-(void)startAction:(int)action{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    switch (action) {
        case ACTION_PHOTO:
            NSLog(@"photo");
            break;
        case ACTION_VIDEO:
            NSLog(@"photo");
            break;
        case ACTION_POST:
            NSLog(@"photo");
            break;
        default:
            NSLog(@"Unknown Action: Closing PostView");
            [self setViewHidden:true];
            break;
    }
}

#pragma mark - CFTabBarViewDelegate method

-(void)setViewHidden:(BOOL)hidden{
    [self.view.superview setHidden:hidden];
    if(!hidden){
        //being shown;
        [menuView showAndSetBackgroundSelectedBlock:^{
            [[[AppDelegate getAppDelegate] appTabBar] goHome];
        }];
    }else{
        //being hidden;
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
}

@end
