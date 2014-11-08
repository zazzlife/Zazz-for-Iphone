//
//  ZazzFollow.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 11/2/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzFollow.h"
#import "ZazzApi.h"

@implementation ZazzFollow

@synthesize _receivedData;

-(void)sendFollowRequest:(NSString*)userId{
    NSString* action = [[NSString alloc] initWithFormat:@"follows/%@",userId];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request delegate:nil];
}


@end