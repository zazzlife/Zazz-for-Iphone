#import "UserTypeController.h"
#import "UserTypeCell.h"

#import "ExtraInfoController.h"


@interface UserTypeController () {
    
    NSArray *_tagLineOptions;
    NSArray *_promoterOptions;
}


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

@end


@implementation UserTypeController


static NSString * const _Identifier = @"Cell";


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
    [_info removeObjectForKey:@"userType"];
    [_info removeObjectForKey:@"majorId"];
    [_info removeObjectForKey:@"promoterType"];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - View's lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _visualize];
    
    [self keyPressed:_taglineButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _localize];
    
    if (_user) {
        [_doneButton setTitle:kText_Finish forState:UIControlStateNormal];
        _doneButton.backgroundColor = kColor_BG_Yellow;
    }
    else {
        [_doneButton setTitle:kText_Next forState:UIControlStateNormal];
        _doneButton.backgroundColor = kColor_BG_Blue;
    }
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
    
    if ([segue.destinationViewController isKindOfClass:[ExtraInfoController class]]) {
        __weak ExtraInfoController *controller = (ExtraInfoController *) segue.destinationViewController;
        controller.user = _user;
        controller.info = _info;
    }
}


#pragma mark - View's key pressed event handlers
- (IBAction)keyPressed:(id)sender {
    if (sender == _taglineButton) {
        self.title = kText_SelectTagline;
        
        _taglineImageView.image  = kImage_Check;
        _promoterImageView.image = nil;
        _taglineButton.selected  = YES;
        _promoterButton.selected = NO;
        
        // Reload table
        [_tableView reloadData];
        
        // Define info
        _info[@"userType"] = @(1);
        [_info removeObjectForKey:@"promoterType"];
    }
    else if (sender == _promoterButton) {
        self.title = kText_PromoterType;
        
        _taglineImageView.image  = nil;
        _promoterImageView.image = kImage_Check;
        _taglineButton.selected  = NO;
        _promoterButton.selected = YES;
        
        // Reload table
        [_tableView reloadData];
        
        // Define info
        _info[@"userType"] = @(2);
        [_info removeObjectForKey:@"majorId"];
    }
    else if (sender == _doneButton) {
        if (!_info[@"majorId"] && !_info[@"promoterType"]) {
            [kAppDelegate presentAlertWithTitle:kText_AppName message:kText_InvalidUserType];
            return;
        }
        
        if (_user) {
            if ([_user[@"gender"] isEqualToStringIgnoreCase:@"Male"]) {
                _info[@"Gender"] = @"Male";
            }
            else {
                _info[@"Gender"] = @"Female";
            }
            
            __autoreleasing NSString *urlString = [NSString stringWithFormat:_g_ServiceRegister, _g_Hostname];
            __autoreleasing FwiRequest *request = [kNetworkManager prepareRequestWithURL:[NSURL URLWithString:urlString] method:kMethodType_Post params:_info];
            
            [SVProgressHUD showWithStatus:kText_Registering];
            [kNetworkManager sendRequest:request handleError:YES completion:^(FwiJson *responseMessage, NSError *error, FwiNetworkStatus statusCode) {
                [SVProgressHUD dismiss];
                
                if (FwiNetworkStatusIsSuccces(statusCode)) {
                    [self.navigationController performSegueWithIdentifier:kSegue_PresentAuthenticatedFlow sender:nil];
                }
            }];
        }
        else {
            [self performSegueWithIdentifier:kSegue_PresentExtraInfoView sender:nil];
        }
    }
}


#pragma mark - Class's properties


#pragma mark - Class's public methods


#pragma mark - Class's private methods
- (void)_init {
    _tagLineOptions = @[kText_BlackoutKing, kText_BeerPongKing, kText_TequillaShots, kText_BodyShots, kText_BeingRaunchy, kText_DancingMyButtOff, kText_GettingKrunk, kText_ChuggingBeer];
    _promoterOptions = @[kText_Artist, kCapText_DJ, kText_NightlifePromoter, kText_Bartender];
}
- (void)_localize {
}
- (void)_visualize {
    _taglineImageView.layer.borderWidth = 1.0f;
    _taglineImageView.layer.cornerRadius = 3.0f;
    _taglineImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _promoterImageView.layer.borderWidth = 1.0f;
    _promoterImageView.layer.cornerRadius = 3.0f;
    _promoterImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _doneButton.layer.cornerRadius = kCornerRadius;
}


#pragma mark - Class's notification handlers


#pragma mark - UITableViewDataSource's members
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_taglineButton.isSelected) {
        return _tagLineOptions.count;
    }
    else if (_promoterButton.isSelected) {
        return _promoterOptions.count;
    }
    else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTypeCell *cell = (UserTypeCell *) [tableView dequeueReusableCellWithIdentifier:_Identifier];
    
    if (_taglineButton.isSelected) {
        cell.titleLabel.text = _tagLineOptions[indexPath.row];
    }
    else if (_promoterButton.isSelected) {
        cell.titleLabel.text = _promoterOptions[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate's members
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row + 1;
    
    if (_taglineButton.isSelected) {
        _info[@"majorId"] = @(index);
    }
    else if (_promoterButton.isSelected) {
        _info[@"promoterType"] = @(index);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41.0f;
}


@end
