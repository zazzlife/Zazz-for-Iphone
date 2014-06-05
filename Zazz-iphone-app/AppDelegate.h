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
