//
//  LoginViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize _username;
@synthesize _password;


-(IBAction)userHitReturn:(id)sender {
    
    [sender resignFirstResponder];
}

-(IBAction)userTappedBackgroud:(id)sender {
    
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.loginprogress.color = [UIColor yellowColor];
    
    CGRect frame = CGRectMake(120, 335, 80, 80);
    
    self.loginprogress = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    
    [self.view addSubview:self.loginprogress];
    
    // Do any additional setup after loading the view.
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return false;
}

-(IBAction)doLogin:(id)sender{
    
    [[[ZazzApi alloc] init] getAuthTokenWithUsername:_username.text andPassword:_password.text delegate:self];
    [self.loginprogress startAnimating];
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}

-(void) finishedZazzAuth:(BOOL)success{
   
    NSLog(@"finishedZazzAuth - success:%s",success?"yes":"no");
    
    if(success){
        [self performSegueWithIdentifier:@"loginComplete" sender:self];
        [self.loginprogress stopAnimating];
    }
    else {
        UIAlertView *loginerror = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:@"Your username or password is incorrect" delegate:nil cancelButtonTitle:@"try again" otherButtonTitles:nil, nil];
        
        [self.loginprogress stopAnimating];
        [loginerror show];
    }
}
@end
