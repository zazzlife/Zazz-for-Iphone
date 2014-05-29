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
    [[AppDelegate zazzApi] getAuthTokenWithUsername:_username.text andPassword:_password.text delegate:self];
    [self.loginprogress startAnimating];
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}

-(void) finishedZazzAuth:(BOOL)success{
   
//    NSLog(@"finishedZazzAuth - success:%s",success?"yes":"no");
    
    if(success){
        [self performSegueWithIdentifier:@"loginComplete" sender:self];
        [self.loginprogress stopAnimating];
        return;
    }
    UIAlertView *loginerror = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:@"Your username or password is incorrect" delegate:nil cancelButtonTitle:@"try again" otherButtonTitles:nil, nil];
    
    [self.loginprogress stopAnimating];
    [loginerror show];
}
@end
