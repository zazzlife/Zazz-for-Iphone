//
//  RightNavigationViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/26/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "RightNavigationViewController.h"
#import "AppDelegate.h"
#import "CategoryStat.h"

@interface RightNavigationViewController ()

@end

@implementation RightNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppDelegate zazzApi] getCategories:self];
}

-(void)gotZazzCategories:(NSMutableArray *)categories{
    for(CategoryStat* category in categories){
//        NSLog(@"category_id:%@ name:%@ userCount:%d", category.category_id, category.name,category.userCount);
    }
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
