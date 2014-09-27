//
//  ZazzPhoto.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzPhoto.h"
#import "ZazzApi.h"

@implementation ZazzPhoto

@synthesize _receivedData;

-(void)postPhoto:(Photo*)photo{
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:@"photos"];
    
    // create request
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    // set Content-Type in HTTP header
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSString* categories = @"";
    for(NSString* categorId in photo.categories){
        if([categories length] <=0)
            categories = [categories stringByAppendingString:[NSString stringWithFormat:@"%@",categorId]];
        else
            categories = [categories stringByAppendingString:[NSString stringWithFormat:@",%@",categorId]];
    }
    NSMutableDictionary* form = [[NSMutableDictionary alloc] init];\
    if(!photo.description) [photo setDescription:@""];
    [form setObject:categories forKey:@"categories"];
    [form setObject:photo.description forKey:@"description"];
    [form setObject:@"True" forKey:@"showInFeed"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in form) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [form objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(photo.image, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=photo; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
//        [body appendData:[@"<IMAGE_DATA>" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSData* data = request.HTTPBody;
    
    NSLog(@"curl %@ -X %@ -H \"Authorization:%@\" -h \"Content-Length:%@\" -H \"Content-Type:%@\" -d '%@' ",
          request.URL,
          request.HTTPMethod,
          [request valueForHTTPHeaderField:@"Authorization"],
          [request valueForHTTPHeaderField:@"Content-Length"],
          [request valueForHTTPHeaderField:@"Content-Type"],
          [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
    );
    
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSString* desc = [httpResponse description];
    NSLog(@"%@",desc);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError* error = nil;
    NSString *myString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"received: %@",myString);
    if(!_receivedData){return;}
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:_receivedData options:0 error:&error ];
    if(array == nil){
        NSString *myString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON ERROR: %@, DATA: %@", error,myString);
    }
    Photo* photo = [Photo makePhotoFromDict:array];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"madePost" object:photo userInfo:nil];
}




@end
