//
//  AppDelegate.h
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 4/14/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZazzApi.h"
#import "CFTabBarController.h"
@class NetworkManager;


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
}

// Query iOS Version
@property (nonatomic, assign, readonly) NSInteger osVersion;

// Application controllers
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, readonly) NetworkManager *networkManager;

@property ZazzApi* _zazzAPI;
@property UIImageView* zazz_logo;
@property UINavigationController* navController;
@property CFTabBarController* appTabBar;
+(void)addZazzBackgroundLogo;
+(void)removeZazzBackgroundLogo;
+(NSString*)toShortTimeStamp:(NSString*)long_timestamp;

+ (AppDelegate*)getAppDelegate;
+ (ZazzApi*)zazzApi;


/** Present alert message. */
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle;
- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle;

@end
