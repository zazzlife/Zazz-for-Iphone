#import "ExtraInfoController.h"


@interface ExtraInfoController () {
    
    NSMutableArray *_ageOptions;
}


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

@end


@implementation ExtraInfoController


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
    [_info removeObjectForKey:@"Gender"];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - View's lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _visualize];
    
    _resignButton.hidden = YES;
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
}


#pragma mark - View's key pressed event handlers
- (IBAction)keyPressed:(id)sender {
    if (sender == _ageButton) {
        _ageButton.selected = YES;
        _resignButton.hidden = NO;
        [self becomeFirstResponder];
        
        NSUInteger index = [_agePickerView selectedRowInComponent:0];
        [self pickerView:_agePickerView didSelectRow:index inComponent:0];
    }
    else if (sender == _maleButton) {
        _maleImageView.image  = kImage_Check;
        _femaleImageView.image = nil;
        
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
        _info[@"Gender"] = @"Male";
    }
    else if (sender == _femaleButton) {
        _maleImageView.image  = nil;
        _femaleImageView.image = kImage_Check;
        
        _maleButton.selected = NO;
        _femaleButton.selected = YES;
        _info[@"Gender"] = @"Female";
    }
    else if (sender == _finishButton) {
        if (!_info[@"Gender"]) {
            [kAppDelegate presentAlertWithTitle:kText_AppName message:kText_InvalidGender];
            return;
        }
        
        __autoreleasing NSString *urlString = [NSString stringWithFormat:_g_ServiceRegister, _g_Hostname];
        __autoreleasing FwiRequest *request = [kNetworkManager prepareRequestWithURL:[NSURL URLWithString:urlString] method:kMethodType_Post params:_info];
        
        [SVProgressHUD showWithStatus:kText_Registering];
        [kNetworkManager sendRequest:request handleError:YES completion:^(FwiJson *responseMessage, NSError *error, FwiNetworkStatus statusCode) {
            [SVProgressHUD dismiss];
            
            if (FwiNetworkStatusIsSuccces(statusCode)) {
                [kPreferences setCurrentUsername:_info[@"username"]];
                [kPreferences setTokenType:[[responseMessage jsonWithPath:@"token_type"] getString]];
                [kPreferences setAccessToken:[[responseMessage jsonWithPath:@"access_token"] getString]];
                [kPreferences setRefreshToken:[[responseMessage jsonWithPath:@"refresh_token"] getString]];
                
                __autoreleasing NSDate *currentTime = [NSDate date];
                __autoreleasing NSDate *expiredTime = [currentTime dateByAddingTimeInterval:[[[responseMessage jsonWithPath:@"expires_in"] getNumber] doubleValue]];
                [kPreferences setExpiredTime:expiredTime];
                [kPreferences save];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else {
        _ageButton.selected = NO;
        _resignButton.hidden = YES;
        [self resignFirstResponder];
    }
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (UIView *)inputView {
    return _agePickerView;
}
- (BOOL)canBecomeFirstResponder {
    return _ageButton.selected;
}


#pragma mark - Class's private methods
- (void)_init {
    if (!_ageOptions) {
        _ageOptions = [NSMutableArray arrayWithCapacity:99];
        for (NSUInteger i = 1; i <= 99; i++) {
            [_ageOptions addObject:@(i)];
        }
    }
}
- (void)_localize {
}
- (void)_visualize {
    _maleImageView.layer.borderWidth = 1.0f;
    _maleImageView.layer.cornerRadius = 3.0f;
    _maleImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _femaleImageView.layer.borderWidth = 1.0f;
    _femaleImageView.layer.cornerRadius = 3.0f;
    _femaleImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [_ageButton setBackgroundImage:kImage_BG_TextField forState:UIControlStateNormal];
    [_ageButton setBackgroundImage:kImage_BG_TextField forState:UIControlStateHighlighted];
    _finishButton.layer.cornerRadius = kCornerRadius;
}


#pragma mark - Class's notification handlers


#pragma mark - UIPickerViewDataSource's members
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _ageOptions.count;
}


#pragma mark - UIPickerViewDelegate's members
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_ageOptions[row] description];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUInteger index = [_agePickerView selectedRowInComponent:0];
    [_ageButton setTitle:[_ageOptions[index] description] forState:UIControlStateNormal];
}


@end
