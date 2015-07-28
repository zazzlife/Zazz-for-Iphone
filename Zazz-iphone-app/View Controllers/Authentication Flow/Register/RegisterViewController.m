#import "RegisterViewController.h"
#import "BasicInfoController.h"


@interface RegisterViewController () {
}

@property (nonatomic, assign) BOOL isForwarded;
@property (nonatomic, strong) id<FBGraphUser> user;


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

/** Handle app did become active. */
- (void)_handleApplicationDidBecomeActiveNotification:(NSNotification *)notification;

@end


@implementation RegisterViewController


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
    
    _facebookView.publishPermissions = @[@"publish_actions", @"public_profile", @"user_friends", @"email"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _localize];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Move forward if user is available
    if (self.user && !_isForwarded) {
        _isForwarded = YES;
        [self performSegueWithIdentifier:kSegue_PresentBasicInfoView sender:nil];
    }
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
    __autoreleasing UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    if ([segue.destinationViewController isKindOfClass:[BasicInfoController class]]) {
        __weak BasicInfoController *controller = (BasicInfoController *) segue.destinationViewController;
        controller.user = _user;
    }
}


#pragma mark - View's key pressed event handlers
- (IBAction)keyPressed:(id)sender {
    if (sender == _registerButton) {
        [self performSegueWithIdentifier:kSegue_PresentBasicInfoView sender:nil];
    }
}


#pragma mark - Class's properties


#pragma mark - Class's public methods


#pragma mark - Class's private methods
- (void)_init {
    _isForwarded = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)_localize {
}
- (void)_visualize {
    _registerButton.layer.cornerRadius = 5.0f;
}


#pragma mark - Class's notification handlers
- (void)_handleApplicationDidBecomeActiveNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self viewDidAppear:YES];
    });
}


#pragma mark - FBLoginViewDelegate's members
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    self.user = user;
    
    if (self.isBeingPresented) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:kSegue_PresentBasicInfoView sender:nil];
        });
    }
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    _isForwarded = NO;
    self.user = nil;
}


@end
