#import "BaseFormController.h"


@interface BaseFormController () <UIGestureRecognizerDelegate> {

    NSNotification         *_keyboardNotification;
    UITapGestureRecognizer *_tapGesture;

    CGRect _originalFrame;
    BOOL _isRegistered;
}

/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

- (void)_handleTapGesture:(UITapGestureRecognizer *)gesture;

/** Handle notifications. */
- (void)_keyboardWillHide:(NSNotification *)notification;
- (void)_keyboardWillShow:(NSNotification *)notification;

@end


@implementation BaseFormController


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
    FwiRelease(_keyboardNotification);

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - View's lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _localize];
    [self _visualize];
    _shouldHandleKeyboardNotificaiton = YES;
    
    if (!_isRegistered) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        _isRegistered = YES;
    }

    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGesture:)];
        _tapGesture.delegate = self;

        [self.view addGestureRecognizer:_tapGesture];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

    // Prepare to get new keyboard notification
    FwiRelease(_keyboardNotification);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


#pragma mark - View's event handler


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (void)updateMovableViewForView:(UIView *)view {
    /* Condition validation */
    if (!_keyboardNotification) return;

    // Update original frame
    if (CGRectEqualToRect(_originalFrame, CGRectZero)) {
        _originalFrame = self.view.frame;
    }

    // Get keyboard appear event's info
    NSDictionary *userInfo = [_keyboardNotification userInfo];
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationCurve = (UIViewAnimationOptions) [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    // Calculate the center of the visible view
    CGRect appFrame = [[kAppDelegate window] bounds];
    CGRect visibleFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // For orientation support, we need this
    visibleFrame.origin.y    = appFrame.size.height - visibleFrame.size.height;
    visibleFrame.size.height = visibleFrame.origin.y;
    visibleFrame.origin.y    = 0.0f;

    // Predecate focus view position just above keyboard 10 pixels
    CGPoint center = CGPointZero;
    center.x = visibleFrame.size.width / 2;
    center.y = visibleFrame.size.height - (view.frame.size.height / 2) - 50.0f;

    // Calculate position
    CGPoint viewCenter  = [view center];
    CGPoint superCenter = [self.view.superview convertPoint:viewCenter fromView:view.superview];

    // Calculate distance to move up
    CGFloat distance = center.y - superCenter.y;


    /* Condition validation: Do not need to update view if the focus view is already visible. */
    if (distance < 0) {
        CGPoint movableCenter = self.view.center;
        movableCenter.y += distance;

        [UIView animateWithDuration:animationTime
                              delay:0.0f
                            options:animationCurve
                         animations:^{
                             [self.view setCenter:movableCenter];
                         }
                         completion:nil];
    }
}


#pragma mark - Class's private methods
- (void)_init {
    _originalFrame = CGRectZero;
}
- (void)_localize {
}
- (void)_visualize {
}

- (void)_handleTapGesture:(UITapGestureRecognizer *)gesture {
    [[kAppDelegate window] findAndResignFirstResponder];
}


#pragma mark - Class's notification handlers
- (void)_keyboardWillHide:(NSNotification *)notification {
    /* Condition validation */
    if (!_shouldHandleKeyboardNotificaiton) return;
    
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationCurve = (UIViewAnimationOptions) [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    [UIView animateWithDuration:animationTime
                          delay:0.0f
                        options:animationCurve
                     animations:^{
                         [self.view setFrame:_originalFrame];
                     }
                     completion:^(BOOL finished) {
                         if (finished) _originalFrame = CGRectZero;
                     }];
}
- (void)_keyboardWillShow:(NSNotification *)notification {
    // Keep notification instance
    if (!_keyboardNotification) _keyboardNotification = notification;

    // Update textfield position
    UIView *txtField = [self.view findFirstResponder];
    [self updateMovableViewForView:txtField];
}


#pragma mark - UITextFieldDelegate's members
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    /* Condition validation */
    if (!_shouldHandleKeyboardNotificaiton) return;
    
    // Re-update textfield position
    [self updateMovableViewForView:textField];
}


@end
