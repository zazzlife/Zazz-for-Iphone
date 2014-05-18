//
//  AsyncImageView.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "AsyncImageView.h"

@implementation AsyncImageView

+ (void)initialize {
    [NSURLCache setSharedURLCache:[[SDURLCache alloc] initWithMemoryCapacity:0
                                                                diskCapacity:10*1024*1024
                                                                    diskPath:[SDURLCache defaultCachePath]]];
}

- (void)setImageFromURL:(NSURL *)url{
    /* Put activity indicator */
    if(!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGRect frame = [activityIndicator frame];
        frame.origin.x = (self.frame.size.width - frame.size.width)/2;
        frame.origin.y = (self.frame.size.height - frame.size.height)/2;
        activityIndicator.tag = 9999;
        activityIndicator.frame = frame;
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
    }
    
    /* Cancel previous request */
    if(fetchImageConnection) {
        [fetchImageConnection cancel];
    }
    [imageData release];
    
    /* Start new request */
    NSURLRequest *req = [NSURLRequest requestWithURL:url
                                         cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                     timeoutInterval:30];
    imageData = [NSMutableData new];
    fetchImageConnection = [NSURLConnection connectionWithRequest:req
                                                         delegate:self];
    [fetchImageConnection retain];
}
- (void)setImageFromDisk:(UIImage *)img {
    self.image = img;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(connection == fetchImageConnection) {
        self.image = [UIImage imageWithData:imageData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDownloaded" object:self];
        
        [activityIndicator removeFromSuperview];
        
        [imageData release];
        [activityIndicator release];
        
        activityIndicator = nil;
        imageData = nil;
        fetchImageConnection = nil;
    }
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    NSLog(@"error: %@", error);
}
@end