//
//  ZazzFeed.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzFeed.h"
#import "Photo.h"
#import "Event.h"
#import "Post.h"
#import "Comment.h"
#import "UIImage.h"

@implementation ZazzFeed

@synthesize _receivedData;

NSString* categories = @"";
NSString* feedId = @"";
NSString* userId = @"";

-(void) doAction:(NSString*)action{
    NSLog(@"action: %@",action);
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//MY-FEED
- (void) getMyFeedAfter:(NSString*)feed_id{
    feedId = feed_id;
    NSString* action = [NSString stringWithFormat:@"feeds?lastFeed=%d", [feed_id intValue]];
    [self doAction:action];
}
- (void) getMyFeed{
    [self getMyFeedAfter:@"-1"];
}

//CATEGORIES
- (void) getFeedCategory:(NSString*)category_id{
    categories = category_id;
    NSString* action = [NSString stringWithFormat:@"categories/%@/feed", category_id];
    [self doAction:action];
}

- (void) getFeedCategory:(NSString*)category_id after:(NSString*)feed_id{
    categories = category_id;
    feedId = feed_id;
    NSString* action = [NSString stringWithFormat:@"categories/%@/feed?lastFeed=%@", category_id, feed_id];
    [self doAction:action];
}


- (void) getUserFeed:(NSString*)user_id{
    userId = user_id;
    NSString* action = [NSString stringWithFormat:@"feeds/%@", user_id];
    [self doAction:action];
}
- (void) getUserFeed:(NSString*)user_id after:(NSString *)feed_id{
    userId = user_id;
    feedId = feed_id;
    NSString* action = [NSString stringWithFormat:@"feeds/%@?lastFeed=%@", user_id, feed_id];
    [self doAction:action];
}


//RESPONSE DELEGATES
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError* error = nil;
    NSString *myString = [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"received: %@",myString);
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:self._receivedData options:0 error:&error ];
    if(array == nil){
        NSString *myString = [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON ERROR: %@, DATA: %@", error,myString);
    }
    NSMutableArray *feedList = [[NSMutableArray alloc] init];
    
    for(NSDictionary* feed_dict in array) {
        Feed* feed = [Feed makeFeedFromDict:feed_dict];
        [feedList addObject:feed];
    }
    
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:feedList forKey:@"feed"];
    [userInfo setObject:feedId forKey:@"feed_id"];
    [userInfo setObject:userId forKey:@"user_id"];
    [userInfo setObject:categories forKey:@"category_ids"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotFeed" object:feedList userInfo:userInfo];
}


@end
