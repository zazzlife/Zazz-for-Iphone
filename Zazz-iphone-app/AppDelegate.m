#import "AppDelegate.h"


@interface AppDelegate () <UIAlertViewDelegate> {
    
    UIAlertView *_alertView;
}

/** Override default controls. */
- (void)_customAppearance;

@end


@implementation AppDelegate

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
    
    // Apply custom theme
    [self _customAppearance];
    return YES;
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
}
- (void)applicationWillTerminate:(UIApplication *)application {
}


#pragma mark - Class's properties
- (NSInteger)osVersion {
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}


#pragma mark - Class's public methods
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    /* Condition validation */
    if (_alertView) return;
    [self presentAlertWithTitle:title message:message delegate:nil];
}
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate {
    /* Condition validation */
    if (_alertView) return;
//    [self presentAlertWithTitle:title message:message delegate:delegate cancelTitle:kText_Dismiss];
}
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelTitle:(NSString *)cancelTitle {
    /* Condition validation */
    if (_alertView) return;
    [self presentAlertWithTitle:title message:message delegate:delegate cancelTitle:cancelTitle confirmTitle:nil];
}
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle {
    /* Condition validation */
    if (_alertView) return;
    
    @synchronized (self) {
        _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:(delegate ? delegate : self) cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
        
        // Present alert view
        dispatch_async(dispatch_get_main_queue(), ^{
            [_alertView show];
        });
    }
}


#pragma mark - Class's private methods
- (void)_customAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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
}


@end
