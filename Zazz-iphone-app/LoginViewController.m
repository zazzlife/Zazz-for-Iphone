//
//  LoginViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor.h"

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
    [self.loginprogress setColor:[UIColor colorFromHexString:COLOR_ZAZZ_YELLOW]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAuthError:) name:@"gotAuthError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAuthToken:) name:@"gotAuthToken" object:nil];
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
    [[AppDelegate zazzApi] getAuthTokenWithUsername:_username.text andPassword:_password.text];
    [self.loginprogress startAnimating];
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}

-(void) gotAuthError:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotAuthError"]) return;
    [self.loginprogress stopAnimating];
    UIAlertView *loginerror = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:@"Your username or password is incorrect" delegate:nil cancelButtonTitle:@"try again" otherButtonTitles:nil, nil];
    [loginerror show];
    return;
}

-(void) gotAuthToken:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotAuthToken"]) return;
    [self.loginprogress stopAnimating];
    [self performSegueWithIdentifier:@"loginComplete" sender:self];
    return;
}
@end
