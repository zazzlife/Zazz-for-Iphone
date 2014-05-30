//
//  ZazzCategory.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"

@interface ZazzCategory : NSObject<NSURLConnectionDataDelegate>

@property ZazzApi* _delegate;

-(void)getCategoriesDelegate:(id)delegate;

@end
