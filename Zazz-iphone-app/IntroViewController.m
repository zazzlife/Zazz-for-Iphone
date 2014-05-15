//
//  IntroViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.view setHidden:true];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view setHidden:false];
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)showLogin:(id)sender{
    
}

-(void)showRegister:(id)sender{
    
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    NSLog(@"pop vuew");
    // trigger your custom back animation here
    
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
