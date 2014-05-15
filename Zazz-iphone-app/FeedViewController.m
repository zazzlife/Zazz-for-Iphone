//
//  FeedTableViewController.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"

@implementation FeedViewController

@synthesize UserImages = _UserImages;
@synthesize Usernames = _Usernames;
@synthesize TimeStamps = _TimeStamps;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // The TableView was scrolling over the status bar so I found this temporary workaround.. I'm sure there's a better way to do this..
    
//    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    // Initialized some profiles with pictures from fb and made up time stamps..
    
    self.UserImages = [[NSArray alloc] initWithObjects: (UIImage *) @"Fyodor.jpg",
                                                                    @"Mitchell.jpg",
                                                                    @"Laurent.jpg",
                                                                    @"Will.jpg",
                                                                    @"Ken.jpg", nil];
    
    
    self.TimeStamps = [[NSArray alloc] initWithObjects: (id) @"11:15:23",
                                                             @"16:18:45",
                                                             @"8:15:16",
                                                             @"17:14:32",
                                                             @"22:11:15", nil];
    
    self.Usernames = [[NSArray alloc] initWithObjects: (id)  @"Fyodor Wolf",
                                                             @"Mitchell Sorkin",
                                                             @"Laurent Vincent",
                                                             @"Will Gasner",
                                                             @"Ken Montero", nil];
    
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.Usernames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedTableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *username = [self.Usernames objectAtIndex: [indexPath row]];
    NSString *timestamp = [self.TimeStamps objectAtIndex: [indexPath row]];
    NSString *imagePath =[self.UserImages objectAtIndex: [indexPath row]];
    
    //This logic should be moved into FeedTableViewCell
    cell.UserName.text = username;
    cell.TimeStamp.text = timestamp;
    cell.UserImage.image = [UIImage imageNamed:imagePath];
    
//    UserProfile *profile = [[UserProfile alloc] initWithUserName:username andImagePath:imagePath ];
//    [cell initWithProfile: profile andTimeStamp: timestamp]
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
