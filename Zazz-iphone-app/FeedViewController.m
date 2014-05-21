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


BOOL left_active = false;

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
    
    [self.sideNav setFrame:CGRectMake(-200, 0, 200, self.view.frame.size.height)];
//    [self.sideNav setBackgroundColor:[UIColor blueColor]];
    
}


-(void)doSwipes:(UIGestureRecognizer *) sender {
    [self leftDrawerButton:nil];
}

-(IBAction)leftDrawerButton:(id)sender {
    if (!left_active){
        [self.tabBarController.view.superview addSubview:self.sideNav];
    }
    [self navigationDrawerAnimation];
    
}
-(void)fadeIn:(NSString*)animationId finished:(NSNumber *)finished context:(void *)context{
    if (!left_active){
        [self.sideNav removeFromSuperview];
    }
}

-(void)navigationDrawerAnimation {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeIn:finished:context:) ];
    [UIView setAnimationDuration:-10];
    
    if(!left_active){
        [self.tabBarController.view setFrame:CGRectMake(200, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.sideNav setFrame:CGRectMake(0, 0, 200, self.view.frame.size.height)];
        left_active = true;
    }else{
        [self.tabBarController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.sideNav setFrame:CGRectMake(-200, 0, 200, self.view.frame.size.height)];
        left_active = false;
    }
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

@end
