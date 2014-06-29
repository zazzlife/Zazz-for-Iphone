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

@synthesize _delegate;
@synthesize _receivedData;

-(void) doAction:(NSString*)action withDelegate:(id)delegate{
    [self set_delegate:delegate];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//MY-FEED
- (void) getMyFeedDelegate:(ZazzApi*)delegate{
    [self doAction:@"feeds" withDelegate:delegate];
}

- (void) getMyFeedAfter:(NSString*)feed_id delegate:(id)delegate{
    NSString* action = [NSString stringWithFormat:@"feeds?lastFeed=%d", [feed_id intValue]];
    [self doAction:action withDelegate:delegate];
}

//OTHER-USER-FEED
- (void) getFeedForUserId:(NSString *)userId delegate:(id)delegate{
    NSString* action = [NSString stringWithFormat:@"feeds/%@",userId];
    [self doAction:action withDelegate:delegate];
}

//CATEGORIES
- (void) getFeedCategory:(NSString*)category_id delegate:(id)delegate{
    NSString* action = [NSString stringWithFormat:@"categories/%@/feed", category_id];
    [self doAction:action withDelegate:delegate];
}

- (void) getFeedCategory:(NSString*)category_id after:(NSString*)feed_id delegate:(id)delegate{
    NSString* action = [NSString stringWithFormat:@"categories/%@/feed?lastFeed=%@", category_id, feed_id];
    [self doAction:action withDelegate:delegate];
}

//RESPONSE DELEGATES
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError* error = nil;
//    NSString *myString = [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",myString);
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:self._receivedData options:0 error:&error ];
    if(array == nil){
        NSString *myString = [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON ERROR: %@, DATA: %@", error,myString);
    }
    NSMutableArray *feedList = [[NSMutableArray alloc] init];
    
    for(NSDictionary* feed_dict in array) {
//        NSLog(@"----------- FEED_DICT -------------");
//        NSLog(@"%@ --- %@",[feed_dict class], feed_dict);
//        NSLog(@"----------- FEED_DICT -------------");
        Profile *user = [[Profile alloc] init];
        [user setPhotoUrl:[[feed_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]];
        [user setUserId:[feed_dict objectForKey:@"userId"]];
        [user setUsername:[feed_dict objectForKey:@"userDisplayName"]];
        
        Feed* feed = [[Feed alloc] init];
        [feed setUser:user];
        [feed setCanCurrentUserRemoveFeed:[[feed_dict objectForKey:@"canCurrentUserRemoveFeed"] boolValue]];
        [feed setFeedId:[feed_dict objectForKey:@"feedId"]];
        [feed setTimestamp:[feed_dict objectForKey:@"time"]];
        [feed setFeedType:[feed_dict objectForKey:@"feedType"]];
        
        //SET COMMENTS
        NSMutableArray* comments = [[NSMutableArray alloc] init];
        for(NSMutableDictionary* comment_dict in [feed_dict objectForKey:@"comments"]){
            Profile* fromUser = [[Profile alloc] init];
            [fromUser setUsername:[comment_dict objectForKey:@"userDisplayName"]];
            
            [fromUser setPhotoUrl:[[comment_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]];
            [fromUser setUserId:[comment_dict objectForKey:@"userId"]];
            Comment* comment = [[Comment alloc] init];
            [comment setUser:fromUser];
            [comment setTime:[comment_dict objectForKey:@"time"]];
            [comment setIsFromCurrentUser:[[comment_dict objectForKey:@"isFromCurrentUser"] boolValue]];
            [comments addObject:comment];
        }
        [feed setComments:comments];
        
        //SET VARIABLE CONTENT
        if([feed.feedType isEqualToString:@"Photo"]){
            NSMutableArray* photos = [[NSMutableArray alloc] init];
            for(NSDictionary* photo_dict in [feed_dict objectForKey:@"photos"]) {
                Photo* photo = [ZazzApi makePhotoFromDict:photo_dict];
                [photos addObject:photo];
            }
            [feed setContent:photos];
        }
        else if([feed.feedType isEqualToString:@"Post"]){
            Post* post = [ZazzApi makePostFromDict:[feed_dict objectForKey:@"post"]];
            [feed setContent:post];
        }else if([feed.feedType isEqualToString:@"Event"]){
            Event* event = [ZazzApi makeEventFromDict:[feed_dict objectForKey:@"apiEvent"]];//THIS WILL NEED TO BE FIXED FOR API V2
            [feed setContent:event];
        }
        [feedList addObject:feed];
    }
    [[self _delegate] gotFeed:feedList];
}


@end
