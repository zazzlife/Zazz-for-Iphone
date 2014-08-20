//
//  AppDelegate.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 4/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "AppDelegate.h"

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
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self set_zazzAPI:[[ZazzApi alloc] init]];
//    [self.window setBackgroundColor:];
    [[self.window rootViewController].view setBackgroundColor:[UIColor clearColor]];
    UINavigationController* navController = (UINavigationController*)[self.window rootViewController];
    [self setNavController:navController];
    [navController.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [AppDelegate addZazzBackgroundLogo];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
