//
//  UIViewController_TagViewController.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "TagViewController.h"
#import "UIView.h"
#import "SearchResult.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@implementation TagViewController

@synthesize titleLabel;
@synthesize searchImage;
@synthesize searchFeild;
@synthesize tag;

-(id)init{
    if(!self)self = [super init];
    UIToolbar* keyboardHelper = [[UIToolbar alloc] init];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardHelper setItems:[NSArray arrayWithObjects: flexibleItem, doneButton, nil]];
    [self.searchFeild setInputAccessoryView:keyboardHelper];
    
    SearchResult* searchRes = [[SearchResult alloc] init];
    [searchRes setTitle:@"firstName"];
    [searchRes setSubTitle:@"some tag"];
    [searchRes setImageUrl:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Smiley.svg/1024px-Smiley.svg.png"]];
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    NSString* title = @"";
    NSString* imageName = @"";
    switch (self.tag) {
    case 0:
        title = @"Tag people";
        imageName = @"TagPerson_icon_for_postingSection";
        break;
    case 1:
        title = @"Share with";
        imageName = @"Lock_icon_postingSection";
        break;
    case 2:
    default:
        title = @"Tag a place";
        imageName = @"@_sign_for_postingSection";
        break;
    }
    [self.titleLabel setText:title];
    [self.searchImage setImage:[UIImage imageNamed:imageName]];
    [[AppDelegate zazzApi] getFollows];
}

- (IBAction)goBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"tagTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    SearchResult* searchResults = [self.dataSource objectAtIndex:indexPath.row];
    [(UILabel*)[cell.contentView subviewWithRestorationIdentifier:@"tag"] setText:searchResults.subTitle];
    [(UILabel*)[cell.contentView subviewWithRestorationIdentifier:@"name"] setText:searchResults.title];
    [(UIImageView*)[cell.contentView subviewWithRestorationIdentifier:@"image"] setImageWithURL:searchResults.imageUrl];
    [(UIImageView*)[cell.contentView subviewWithRestorationIdentifier:@"is_selected"] setHidden:!searchResults.is_selected];
    return cell;
}

@end
