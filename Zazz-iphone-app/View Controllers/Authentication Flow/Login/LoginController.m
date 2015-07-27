#import "LoginController.h"
#import "UIColor.h"


@interface LoginController () {
}


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

@end

@implementation LoginController


#pragma mark - Class's constructors
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - View's lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self _visualize];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _localize];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark - View's memory handler
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View's orientation handler
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


#pragma mark - View's status handler
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - View's transition event handler
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


#pragma mark - View's key pressed event handlers
- (IBAction)keyPressed:(id)sender {
    if (sender == _loginButton) {
        [[AppDelegate zazzApi] getAuthTokenWithUsername:_usernameTextField.text andPassword:_passwordTextField.text];
    }
}


#pragma mark - Class's properties


#pragma mark - Class's public methods


#pragma mark - Class's private methods
- (void)_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAuthError:) name:@"gotAuthError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAuthToken:) name:@"gotAuthToken" object:nil];
}
- (void)_localize {
}
- (void)_visualize {
    _loginImageView.image = kImage_BG_Login;
    _loginButton.layer.cornerRadius = 5.0f;
}


#pragma mark - Class's notification handlers
- (void)gotAuthError:(NSNotification*)notif {
    if (![notif.name isEqualToString:@"gotAuthError"]) return;
    
    UIAlertView *loginerror = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:@"Your username or password is incorrect" delegate:nil cancelButtonTitle:@"try again" otherButtonTitles:nil, nil];
    [loginerror show];
}

- (void)gotAuthToken:(NSNotification*)notif {
    if (![notif.name isEqualToString:@"gotAuthToken"]) return;
    [self performSegueWithIdentifier:@"loginComplete" sender:self];
}


#pragma mark - UITextFieldDelegate's members
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField) {
        [textField resignFirstResponder];
        [self keyPressed:_loginButton];
    }
    return YES;
}


@end
