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
#import "UIColor.h"

@interface RightNavigationViewController ()

@end

@implementation RightNavigationViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotZazzCategories:) name:@"gotCategories" object:nil];
    [[AppDelegate zazzApi] getCategories];
    [self.tableView setScrollsToTop:false];
    [self.tableView setBackgroundColor:[UIColor colorFromHexString:APPLICATION_BLACK]];
}

-(void)gotZazzCategories:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotCategories"]) return;
    [self setCategories:[notif.userInfo objectForKey:@"categories"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categories count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* CellIdentifier = @"categoryCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    UILabel* name = (UILabel*)[cell viewWithTag:2];
    UILabel* talking = (UILabel*)[cell viewWithTag:3];
    
    CategoryStat* category = [self.categories objectAtIndex:indexPath.row];
    [imageView setImage:[category getIcon]];
    [name setText:category.name];
    [talking setText:[NSString stringWithFormat:@"%d talking about this",category.userCount]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;
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
