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

@implementation ZazzFeed

@synthesize _delegate;


- (void) getMyFeedDelegate:(ZazzApi*)delegate{
    
    receivedData = [[NSMutableData alloc] init];
    [self set_delegate:delegate];
    
    NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";
    NSString * api_action =  [BASE_URL stringByAppendingString:@"feeds"];
    NSString * token_bearer = [NSString stringWithFormat:@"Bearer %@", [delegate auth_token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"GET"];
    [request setValue: token_bearer forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) getFeedForUserId:(NSString *)userId delegate:(id)delegate{
    
    [self set_delegate:delegate];
    
    NSString * BASE_URL = @"http://test.zazzlife.com/api/v1/";
    NSString * api_action =  [BASE_URL stringByAppendingString:[NSString stringWithFormat:@"feeds/%@",userId]];
    NSString * token_bearer = [NSString stringWithFormat:@"Bearer %@", [delegate auth_token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setHTTPMethod:@"GET"];
    [request setValue: token_bearer forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

NSMutableData* receivedData;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil ];
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray *feedList = [[NSMutableArray alloc] init];
    
    for(NSDictionary* feed_dict in array) {
        
        //        NSLog(@"%@ --- %@",[feed_dict class], feed_dict);
        
        Profile *user = [[Profile alloc] init];
        [user setPhoto:[ZazzApi getImageAtUrl:[[feed_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]]];
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
            [fromUser setPhoto:[ZazzApi getImageAtUrl:[[comment_dict objectForKey:@"userDisplayPhoto"] objectForKey:@"mediumLink"]]];
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
                Photo* photo = [[Photo alloc] init];
                [photo setUser:user];
                [photo setDescription:(NSString*)[photo_dict objectForKey:@"description"]];
                [photo setPhotoId:(NSString*)[photo_dict objectForKey:@"photoId"]];
                [photo setPhoto:[ZazzApi getImageAtUrl:[[photo_dict objectForKey:@"photoLinks"] objectForKey:@"mediumLink"]]];
                [photos addObject:photo];
            }
            [feed setContent:photos];
        }
        else if([feed.feedType isEqualToString:@"Post"]){
            NSMutableDictionary* post_dict = [feed_dict objectForKey:@"post"];
            Post* post = [[Post alloc] init];
            [post setMessage:[post_dict objectForKey:@"message"]];
            [post setTimestamp:[post_dict objectForKey:@"time"]];
            [post setPostId:[post_dict objectForKey:@"postId"]];
            Profile* fromUser = [[Profile alloc] init];
            [fromUser setUserId:[post_dict objectForKey:@"fromUserId"]];
            [fromUser setUsername:[post_dict objectForKey:@"fromUserDisplayName"]];
            [fromUser setPhoto:[ZazzApi getImageAtUrl:[[post_dict objectForKey:@"fromUserDisplayPhoto"] objectForKey:@"mediumLink"]]];
            [post setFromUser:fromUser];
            if([post_dict objectForKey:@"toUserId"]){
                Profile* toUser = [[Profile alloc] init];
                [toUser setUserId:[post_dict objectForKey:@"toUserId"]];
                [toUser setUsername:[post_dict objectForKey:@"fromUserDisplayName"]];
                [toUser setPhoto:[ZazzApi getImageAtUrl:[[post_dict objectForKey:@"fromUserDisplayPhoto"] objectForKey:@"mediumLink"]]];
                [post setToUser:toUser];
            }
            [feed setContent:post];
        }else if([feed.feedType isEqualToString:@"Event"]){
            NSMutableDictionary* event_dict  = [feed_dict objectForKey:@"apiEvent"];//THIS WILL NEED TO BE FIXED FOR API V2
            Event* event = [[Event alloc] init];
            [event setUser:user];
            [event setEventId:[event_dict objectForKey:@"eventId"]];
            [event setName:[event_dict objectForKey:@"name"]];
            [event setDescription:[event_dict objectForKey:@"description"]];
            [event setTime:[event_dict objectForKey:@"time"]];
            [event setUtcTime:[event_dict objectForKey:@"utcTime"]];
            [event setLocation:[event_dict objectForKey:@"location"]];
            [event setStreet:[event_dict objectForKey:@"street"]];
            [event setCity:[event_dict objectForKey:@"city"]];
            [event setPrice:[event_dict objectForKey:@"price"]];
            [event setLatitude:[event_dict objectForKey:@"latitude"]];
            [event setLongitude:[event_dict objectForKey:@"longitude"]];
            [event setCreatedTime:[event_dict objectForKey:@"createdTime"]];
            [event setFacebookLink:[event_dict objectForKey:@"facebookLink"]];
            [event setImage:[ZazzApi getImageAtUrl:[[event_dict objectForKey:@"imageUrl"] objectForKey:@"mediumLink"]]];
            [event setIsDateOnly:[[event_dict objectForKey:@"isDateOnly"] boolValue]];
            [event setIsFacebookEvent:[[event_dict objectForKey:@"isFacebookEvent"] boolValue]];
            [feed setContent:event];
        }
        [feedList addObject:feed];
    }
    [[self _delegate] gotFeed:feedList];
}


@end
