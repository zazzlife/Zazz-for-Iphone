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

#define APPLICATION_BLACK @"#242424"
#define APPLICATION_GREY @"#453F3F"
#define APPLICATION_YELLOW @"##F8C034"

@protocol ViewAnimationDelegate <NSObject>

-(void)viewDidFinishAnimation;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property ZazzApi* _zazzAPI;
@property UIImageView* zazz_logo;
@property CFTabBarController* appTabBar;
+(void)addZazzBackgroundLogo;
+(void)removeZazzBackgroundLogo;

+ (AppDelegate*)getAppDelegate;
+ (ZazzApi*)zazzApi;

@end
