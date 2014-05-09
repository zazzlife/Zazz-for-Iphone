//
//  ZAZZCaller.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/8/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzApi.h"

@implementation ZazzApi

NSMutableData *receivedData;
NSURLConnection *theConnection;

+ (void) makeCall{
    
//    NSString *BASE_URL = @"http://test.zazzlife.com/api/v1/";
//    NSString *api_action =  [BASE_URL stringByAppendingString:@"token"];
//    NSString *postString = @"grant_type=password&username=user&password=123&scope=full";
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString   stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSURLConnection * connection = [NSURLConnection connectionWithRequest:request delegate:self];

    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    receivedData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        
        // Inform the user that the connection failed.
    }
    
    
    NSLog(@"connectionWithRequest");
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Connection didReceiveResponse");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
//    [_responseData appendData:data];
//    NSError *jsonParsingError = nil;
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//    NSString * response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"GOT DATA:%@ --- [0]%@", response, [array objectAtIndex:0]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection didFailWithError");
    theConnection = nil;
    receivedData = nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    theConnection = nil;
    receivedData = nil;
}



@end
