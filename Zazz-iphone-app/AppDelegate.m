//
//  AppDelegate.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 4/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize zazzAPI;
@synthesize zazz_logo;

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
#define UIColorFromRGBA(rgbValue) 
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:((float)((rgbValue & 0xFF))/255.0)];

//    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 24)/255.0 green:((rgbValue & 0xFF00) >> 16)/255.0 blue:((rgbValue & 0xFF) >> 8)/255.0 alpha:1.0];
}

+(AppDelegate*)getAppDelegate{
    return [[UIApplication sharedApplication] delegate];
}
-(void)addZazzBackgorundLogo{
    UIImage* image = [UIImage imageNamed:@"Logo"];
    [self setZazz_logo:[[UIImageView alloc] initWithImage:image]];
    int scale = 2;
    [self.zazz_logo setFrame:CGRectMake(
                                   ((self.window.frame.size.width/2) - (image.size.width/scale/2) ),
                                   ((self.window.frame.size.height/4) - (image.size.height/scale/2)),
                                   image.size.width/scale,
                                   image.size.height/scale
                                   )];
    [self.window addSubview:zazz_logo];
}

-(void)removeZazzBackgroundLogo{
    [self.zazz_logo removeFromSuperview];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Landing page (LH)1"]]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self addZazzBackgorundLogo];
    [self setZazzAPI:[[ZazzApi alloc] init]];
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
