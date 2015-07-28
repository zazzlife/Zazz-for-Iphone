//
//  RegisterViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/11/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController ()

@end


@implementation RegisterViewController

@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize username;
@synthesize password;
@synthesize type;

- (void)viewDidFinishAnimation{
    [self.firstName becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    genders = [NSArray arrayWithObjects:@"Male", @"Female", @"Other", nil];
    genderStr = @"";
    [type selectRow:0 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAuthError:) name:@"gotAuthError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAuthToken:) name:@"gotAuthToken" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotAuthError" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotAuthToken" object:nil];
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

#pragma mark User Actions

-(void)userHitReturn:(id)sender {
    [self removeKeyboard];
}

-(IBAction)userTappedBackgroud:(id)sender {
    [self removeKeyboard];
}

-(void)removeKeyboard {
    for(UITextField* txtF in self.view.subviews) {
        if ([txtF isKindOfClass:[UITextField class]]) {
            [txtF resignFirstResponder];
        }
    }
}

-(IBAction)doRegistration:(id)sender{
    for(UITextField* txtF in self.view.subviews) {
        if ([txtF isKindOfClass:[UITextField class]]) {
            txtF.text = [txtF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([txtF.text  isEqualToString:@""]) {
                [txtF becomeFirstResponder];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Zazz" message:@"Please fill all of the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            [txtF resignFirstResponder];
        }
    }
    if ([genderStr isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Zazz" message:@"Please choose your gender." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary* parameters = @{username.text:@"username",
                                 email.text:@"email",
                                 password.text:@"password",
                                 genderStr:@"Gender",
                                 [firstName.text stringByAppendingFormat:@"+%@", lastName.text]:@"fullName",
                                 @"User":@"accountType"
                                 };
    NSLog(@"%@", parameters);
    [[AppDelegate zazzApi] registerWithDict:parameters];
    [self.registerProgress startAnimating];
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:true];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == password) {
        if (textField.text.length + string.length <= 20) {
            return YES;
        }
        
        return NO;
    }
    return YES;
    
}

#pragma mark Picker 

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return genders.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return genders[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    genderStr = genders[row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}



#pragma mark Auth
-(void) gotAuthError:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotAuthError"]) return;
    [self.registerProgress stopAnimating];
    UIAlertView *loginerror = [[UIAlertView alloc] initWithTitle:@"Register Failed!" message:@"Registration failed" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
    [loginerror show];
    return;
}

-(void) gotAuthToken:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotAuthToken"]) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotAuthToken" object:nil];
    [self.registerProgress stopAnimating];
    [self performSegueWithIdentifier:@"registerComplete" sender:self];
    return;
}

@end
