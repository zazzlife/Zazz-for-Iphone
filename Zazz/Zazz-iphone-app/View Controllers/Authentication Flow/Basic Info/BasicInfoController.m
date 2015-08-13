#import "BasicInfoController.h"
#import "UserTypeController.h"


@interface BasicInfoController () {
}

@property (nonatomic, strong) NSMutableDictionary *info;


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

@end


@implementation BasicInfoController


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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _visualize];
    
    if (_user) {
        _emailTextField.text = _user[@"email"];
        _confirmTextField.text = _user[@"email"];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _localize];
}
- (void)viewDidAppear:(BOOL)animated {
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
    return UIStatusBarStyleDefault;
}

#pragma mark - View's transition event handler
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __autoreleasing UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    if ([segue.destinationViewController isKindOfClass:[UserTypeController class]]) {
        __weak UserTypeController *controller = (UserTypeController *) segue.destinationViewController;
        controller.user = _user;
        controller.info = _info;
    }
}

#pragma mark - View's key pressed event handlers
- (IBAction)keyPressed:(id)sender {
    if (sender == _nextButton) {
        __autoreleasing NSString *username = [_usernameTextField.text trim];
        __autoreleasing NSString *password = [_passwordTextField.text trim];
        __autoreleasing NSString *email = [_emailTextField.text trim];
        __autoreleasing NSString *emailConfirm = [_confirmTextField.text trim];
        
        // Validation input
        if (![username matchPattern:@"^(\\w|\\d)+$"]) {
            [kAppDelegate presentAlertWithTitle:kText_AppName message:kText_InvalidUsername];
            return;
        }
        
        if (![email matchPattern:@"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"]) {
            [kAppDelegate presentAlertWithTitle:kText_AppName message:kText_InvalidEmail];
            return;
        }
        
        if (![emailConfirm isEqualToString:email]) {
            [kAppDelegate presentAlertWithTitle:kText_AppName message:kText_InvalidConfirmEmail];
            return;
        }
        
        NSUInteger length = password.length;
        if (!(8 <= length && length <= 20)) {
            [kAppDelegate presentAlertWithTitle:kText_AppName message:kText_InvalidPassword];
            return;
        }
        
        _info = [NSMutableDictionary dictionaryWithCapacity:10];
        _info[@"accountType"] = @"User";
        _info[@"username"] = username;
        _info[@"password"] = password;
        _info[@"email"] = email;
        
        if (_user && _user[@"name"]) {
            _info[@"fullName"] = _user[@"name"];
        }
        [self performSegueWithIdentifier:kSegue_PresentUserTypeView sender:nil];
    }
}


#pragma mark - Class's properties


#pragma mark - Class's public methods


#pragma mark - Class's private methods
- (void)_init {
}
- (void)_localize {
}
- (void)_visualize {
    _nextButton.layer.cornerRadius = kCornerRadius;
}


#pragma mark - Class's notification handlers


#pragma mark - UITextFieldDelegate's members
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameTextField) {
        [_emailTextField becomeFirstResponder];
    }
    else if (textField == _emailTextField) {
        [_confirmTextField becomeFirstResponder];
    }
    else if (textField == _confirmTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField) {
        [textField resignFirstResponder];
        [self keyPressed:_nextButton];
    }
    return YES;
}


@end
