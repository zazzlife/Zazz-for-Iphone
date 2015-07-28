//  Project name: Zazz-iphone-app
//  File name   : Config.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 6/27/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Mitchell Sorkin. All rights reserved.
//  --------------------------------------------------------------

#ifndef __CONFIG__
#define __CONFIG__


#define kAppDelegate                                        (AppDelegate *) [[UIApplication sharedApplication] delegate]

// Animation configuration
#define kAnimation_Option                                   UIViewAnimationOptionCurveEaseOut
// iOS6 animation configs
#define kAnimation_iOS6_Duration                            0.30f
#define kAnimation_iOS6_Transition                          0.30f
// iOS7 animation configs
#define kAnimation_iOS7_Damping                             0.85f
#define kAnimation_iOS7_Duration                            0.50f
#define kAnimation_iOS7_Velocity                            5.00f

// Define flow

// Define view
#define kSegue_PresentBasicInfoView                         @"presentBasicInfoView"
#define kSegue_PresentExtraInfoView                         @"presentExtraInfoView"
#define kSegue_PresentLoginView                             @"presentLoginView"
#define kSegue_PresentUserTypeView                          @"presentUserTypeView"

// Define notification

// Define categories

// Define json keys


#endif