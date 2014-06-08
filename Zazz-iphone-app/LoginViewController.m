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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // post-load logic.
}

- (void)viewDidFinishAnimation{
    [self._username becomeFirstResponder];
}

/*
 Hanldle keyboard return keys, to go to tnext field or login on password.
 **/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField == self._username ) { [self._password becomeFirstResponder]; }
    if ( textField == self._password ) { [self doLogin:textField];}
    return YES;
}

-(IBAction)doLogin:(id)sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAuthToken:) name:@"gotAuthToken" object:nil];
    [[AppDelegate zazzApi] getAuthTokenWithUsername:_username.text andPassword:_password.text];
    [self.loginprogress startAnimating];
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}

-(void) gotAuthToken:(NSNotification*)notif{
   
//    NSLog(@"finishedZazzAuth - success:%s",success?"yes":"no");
    if (![notif.name isEqualToString:@"gotAuthToken"]) return;
    NSString* auth_token = [notif.userInfo objectForKey:@"token"];
    if (!auth_token){
        UIAlertView *loginerror = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:@"Your username or password is incorrect" delegate:nil cancelButtonTitle:@"try again" otherButtonTitles:nil, nil];
        
        [self.loginprogress stopAnimating];
        [loginerror show];
        return;
    }
    [self performSegueWithIdentifier:@"loginComplete" sender:self];
    [self.loginprogress stopAnimating];
    return;
}
@end
