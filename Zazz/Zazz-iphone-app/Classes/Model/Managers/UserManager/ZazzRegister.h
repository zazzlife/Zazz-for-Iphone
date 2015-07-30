//
//  ZazzRegister.h
//  Zazz-iphone-app
//
//  Created by Serdar ÇINAR on 09/12/14.
//  Copyright (c) 2014 Hasan Serdar ÇINAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZazzApi.h"

@interface ZazzRegister : NSObject<NSURLConnectionDataDelegate>

@property ZazzApi* _delegate;

-(void)registerWithDict:(NSDictionary*)dict delegate:(id)delegate;


@end
