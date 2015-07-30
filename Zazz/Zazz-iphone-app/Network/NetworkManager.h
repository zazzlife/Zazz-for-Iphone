//  Project name: Zazz-iphone-app
//  File name   : NetworkManager.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/30/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Hasan Serdar ÇINAR. All rights reserved.
//  --------------------------------------------------------------

#import <Foundation/Foundation.h>


@interface NetworkManager : NSObject {
}


/** Generate generic HTTP Request. */
- (FwiRequest *)prepareRequestWithURL:(NSURL *)url method:(FwiMethodType)method params:(NSDictionary *)params;

/** Send request to server. */
- (void)sendRequest:(FwiRequest *)request handleError:(BOOL)handleError completion:(void(^)(FwiJson *responseMessage, NSError *error, FwiNetworkStatus statusCode))completion;

@end
