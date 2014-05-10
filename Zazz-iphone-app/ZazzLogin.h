//
//  ZazzLogin.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"

@interface ZazzLogin: NSObject<NSURLConnectionDataDelegate>

@property ZazzApi* _delegate;

- (void) loginWithUsername:(NSString*)username andPassword:(NSString*)password withDelegate:(id)delegate;

@end