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

@synthesize recognizer_close_drawer;
@synthesize recognizer_open_drawer;
@synthesize navigationDrawerLeftWidth;
@synthesize navigationDrawerLeftX;

@synthesize UserImages = _UserImages;
@synthesize Usernames = _Usernames;
@synthesize TimeStamps = _TimeStamps;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navigationDrawerLeftWidth = self.view.frame.size.width * 0.75;
    navigationDrawerLeftX = self.view.frame.origin.x - navigationDrawerLeftWidth;
    navigationDrawerLeft = [[UIView alloc] initWithFrame:CGRectMake(navigationDrawerLeftX, self.view.frame.origin.y, navigationDrawerLeftWidth, self.view.frame.size.height)];
    
    navigationDrawerLeft.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Landing page (LH)1.png"]];
    
    recognizer_open_drawer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipes:)];
    recognizer_close_drawer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipes:)];
    
    recognizer_close_drawer.direction = UISwipeGestureRecognizerDirectionLeft;
    recognizer_open_drawer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:recognizer_open_drawer];
    [self.view addGestureRecognizer:recognizer_close_drawer];
    
    [self.view addSubview:navigationDrawerLeft];
    
    
    
    // The TableView was scrolling over the status bar so I found this temporary workaround.. I'm sure there's a better way to do this..
    
    // self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
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

-(void)doSwipes:(UIGestureRecognizer *) sender {
    
    [self navigationDrawerAnimation];
}

-(IBAction)leftDrawerButton:(id)sender {
    
    [self navigationDrawerAnimation];
    
}

-(void)navigationDrawerAnimation {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:-10];
    
    UIView* testSideNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [testSideNav setBackgroundColor:[UIColor blueColor]];
    [self.tabBarController.view.superview addSubview:testSideNav];
    [self.tabBarController.view setFrame:CGRectMake(200, 20, 200, 200)];
    
    CGFloat moved_x = 0;
    
    if (navigationDrawerLeft.frame.origin.x < self.view.frame.origin.x) {
        
        moved_x = navigationDrawerLeft.frame.origin.x + navigationDrawerLeftWidth;
    }
    
    else {
        
        moved_x = navigationDrawerLeft.frame.origin.x - navigationDrawerLeftWidth;
    }
    
    navigationDrawerLeft.frame = CGRectMake(moved_x, navigationDrawerLeft.frame.origin.y, navigationDrawerLeft.frame.size.width, navigationDrawerLeft.frame.size.height);
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
