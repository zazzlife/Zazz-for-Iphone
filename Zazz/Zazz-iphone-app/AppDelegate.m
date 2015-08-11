#import "AppDelegate.h"


@interface AppDelegate () <UIAlertViewDelegate> {
    
    UIAlertView *_alertView;
}

/** Override default controls. */
- (void)_customAppearance;

/** Handle Facebook call back. */
- (void)_handleOpenURLWithAccessToken:(FBAccessTokenData *)token;

@end


@implementation AppDelegate


@synthesize networkManager=_networkManager, preferences=_preferences;


@synthesize _zazzAPI;
@synthesize zazz_logo;
@synthesize appTabBar;
@synthesize navController;

+(AppDelegate*)getAppDelegate{
    return [[UIApplication sharedApplication] delegate];
}
+(ZazzApi*)zazzApi{
    return [[AppDelegate getAppDelegate] _zazzAPI];
}


+(void)addZazzBackgroundLogo{
    AppDelegate* app = [AppDelegate getAppDelegate];
    UIImage* image = [UIImage imageNamed:@"zazz_final_logo"];
    [app setZazz_logo:[[UIImageView alloc] initWithImage:image]];
    int scale = 2;
    [app.zazz_logo setFrame:CGRectMake(
                                   ((app.window.frame.size.width/2) - (image.size.width/scale/2) ),
                                   ((app.window.frame.size.height/4) - (image.size.height/scale/2)),
                                   image.size.width/scale,
                                   image.size.height/scale
                                   )];
    [app.navController.view addSubview:app.zazz_logo];
}

+(void)removeZazzBackgroundLogo{
    AppDelegate* app = [AppDelegate getAppDelegate];
    [app.zazz_logo removeFromSuperview];
}

+(NSString*)toShortTimeStamp:(NSString*)long_timestamp{
    NSString* short_timestamp = @"";
    return short_timestamp;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (![[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] || ![[UIDevice currentDevice] isMultitaskingSupported]) return NO;
    [self _customAppearance];
    
    // Initialize preferences
    _preferences = [[UserPreferences alloc] init];
    
    // Initialize network manager
    _networkManager = [[NetworkManager alloc] init];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        if (call.accessTokenData) {
                            if ([FBSession activeSession].isOpen) {
                                DLog(@"INFO: Ignoring new access token because current session is open.");
                            }
                            else {
                                [self _handleOpenURLWithAccessToken:call.accessTokenData];
                            }
                        }
                    }];
}

#pragma mark - Cleanup memory
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - Application's lifecycle
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [FBSession.activeSession close];
}

#pragma mark - Class's properties
- (NSInteger)osVersion {
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}

#pragma mark - Class's public methods
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    /* Condition validation */
    if (_alertView) return;
    [self presentAlertWithTitle:title message:message cancelTitle:kText_Dismiss];
}
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle {
    /* Condition validation */
    if (_alertView) return;
    [self presentAlertWithTitle:title message:message cancelTitle:cancelTitle confirmTitle:nil];
}
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle {
    /* Condition validation */
    if (_alertView) return;
    
    @synchronized (self) {
        _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
        
        // Present alert view
        dispatch_async(dispatch_get_main_queue(), ^{
            [_alertView show];
        });
    }
}

#pragma mark - Class's private methods
- (void)_customAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Customize progress hub
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:kColor_BG_Overlay];
    
    // Customize navigation bar
    __autoreleasing UIImage *navBar = [[UIImage imageNamed:@"BG_NavBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:FwiColorWithRGB(0xffbf00),
                                                           NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:20.0f]}];
    
    if (self.osVersion >= 7) {
        __autoreleasing UIImage *navBack = [[UIImage imageNamed:@"Nav_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [[UINavigationBar appearance] setBackIndicatorImage:navBack];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:navBack];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-2.0f forBarMetrics:UIBarMetricsDefault];
    }
    
    // Customize textfield
    __autoreleasing UIImage *textField = [[UIImage imageNamed:@"BG_TextField"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [[UITextField appearance] setTextColor:FwiColorWithRGB(0x4e4e4e)];
    [[UITextField appearance] setBorderStyle:UITextBorderStyleNone];
    [[UITextField appearance] setBackground:textField];
}

- (void)_handleOpenURLWithAccessToken:(FBAccessTokenData *)token {
    // Initialize a new blank session instance...
    __autoreleasing FBSession *sessionFromToken = [[FBSession alloc] initWithAppID:nil
                                                                       permissions:nil
                                                                   defaultAudience:FBSessionDefaultAudienceNone
                                                                   urlSchemeSuffix:nil
                                                                tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance]];
    [FBSession setActiveSession:sessionFromToken];
    
    // And open it from the supplied token.
    [sessionFromToken openFromAccessTokenData:token
                            completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                if (error) {
                                    NSString *alertMessage = nil;
                                    
                                    if ([FBErrorUtility shouldNotifyUserForError:error]) {
                                        alertMessage = [FBErrorUtility userMessageForError:error];
                                    }
                                    else {
                                        switch ([FBErrorUtility errorCategoryForError:error]) {
                                            case FBErrorCategoryAuthenticationReopenSession: {
                                                alertMessage = @"Your current session is no longer valid. Please log in again.";
                                                break;
                                            }
                                            case FBErrorCategoryUserCancelled: {
                                                break;
                                            }
                                            default: {
                                                alertMessage = @"Error. Please try again later.";
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if (alertMessage) {
//                                        [self presentAlertWithTitle:kText_ConceptKeywords message:alertMessage];
                                    }
                                }
                            }];
}


#pragma mark - Class's notification handlers


#pragma mark - UIAlertViewDelegate's members
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _alertView = nil;
}

@end
