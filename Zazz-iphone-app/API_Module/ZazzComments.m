//
//  ZazzComments.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/16/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzComments.h"
#import "ZazzApi.h"

@implementation ZazzComments

NSString* _feedType;
NSString* _feedId;

-(void)getCommentsFor:(NSString*)feedType andId:(NSString*)feedId{
    _feedType = feedType;
    _feedId = feedId;
    NSString * action = [NSString stringWithFormat:@"comments/%@s/%@", feedType, feedId];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)getCommentsFor:(NSString*)feedType andId:(NSString*)feedId after:(NSString*)commentId{
    _feedType = feedType;
    _feedId = feedId;
    NSString * action = [NSString stringWithFormat:@"comments/%@s/%@?lastComment=%@", feedType, feedId, commentId];
    NSLog(@"doing: %@",action);
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *comments_dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
    if(comments_dict == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray* comments = [[NSMutableArray alloc] init];
    
    for(NSDictionary* comment_dict in comments_dict){
        Comment* comment = [Comment makeCommentFromDict:comment_dict];
        [comments addObject:comment];
    }
    
    NSMutableDictionary* userInfo= [[NSMutableDictionary alloc] init];
    [userInfo setObject:_feedType forKey:@"type"];
    [userInfo setObject:_feedId  forKey:@"feedId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotComments" object:comments userInfo:userInfo];
}

@end
