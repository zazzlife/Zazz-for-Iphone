//
//  RightNavigationViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/26/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "RightNavigationViewController.h"
#import "AppDelegate.h"
#import "FeedViewController.h"
#import "CategoryStat.h"
#import "UIColor.h"

@interface RightNavigationViewController ()

@end

@implementation RightNavigationViewController

@synthesize tableView;

- (void)viewDidLoad{
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categories count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryStat* category = [self.categories objectAtIndex:indexPath.row];
    bool active = [(FeedViewController*)self.parentViewController setActiveCategory:category.category_id];
    [self tableViewCell:[self.tableView cellForRowAtIndexPath:indexPath] setSelected:active];
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
    UIColor* textColor = [UIColor whiteColor];
    [name setTextColor:textColor];
    [talking setTextColor:textColor];
    
    CategoryStat* category = [self.categories objectAtIndex:indexPath.row];
    [imageView setImage:[category getIcon]];
    [name setText:category.name];
    [talking setText:[NSString stringWithFormat:@"%d talking about this",category.userCount]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;
}

-(void)tableViewCell:(UITableViewCell*)cell setSelected:(BOOL)selected{
    UIColor* textColor = [UIColor whiteColor];
    if(selected){
        textColor = [UIColor colorFromHexString:APPLICATION_YELLOW];
    }
    UILabel* name = (UILabel*)[cell viewWithTag:2];
    UILabel* talking = (UILabel*)[cell viewWithTag:3];
    [name setTextColor:textColor];
    [talking setTextColor:textColor];
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
