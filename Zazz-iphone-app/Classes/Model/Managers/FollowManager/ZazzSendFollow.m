//
//  ZazzSendFollow.m
//  Zazz-iphone-app
//
//  Created by Serdar ÇINAR on 10/12/14.
//  Copyright (c) 2014 Hasan Serdar ÇINAR. All rights reserved.
//

#import "ZazzSendFollow.h"

@implementation ZazzSendFollow
@synthesize _receivedData;

-(void)setUserToFollow:(NSString *)userId action:(BOOL)follow {
    NSString* action = @"follows";
    if (!follow) {
        action = [NSString stringWithFormat:@"follows/%@", userId];
    }
    
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    if (follow) {
        [request setHTTPMethod:@"POST"];
        NSDictionary* form = @{userId:@"userId"};
        NSString* postString = [ZazzApi getQueryStringFromDictionary:form];
        NSLog(@"%@", postString);
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [request setHTTPMethod:@"DELETE"];
    }
    

    [NSURLConnection connectionWithRequest:request delegate:self];
}

/*- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}
*/
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"response : %ld", [httpResponse statusCode]);
}


/*-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *myString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"received: %@",myString);
}*/




@end
