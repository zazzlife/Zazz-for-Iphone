//
//  ZazzMe.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzProfile.h"
#import "Profile.h"

@implementation ZazzProfile

NSString* _profileId;
NSMutableData* _recievedData;

-(void) getProfile:(NSString *)userId{
    _profileId = userId;
    NSString* action = [[NSString alloc] initWithFormat:@"users/%@/profile",userId];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!_recievedData) _recievedData = [[NSMutableData alloc]init];
    [_recievedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *profile_dict = [NSJSONSerialization JSONObjectWithData:_recievedData options:0 error:nil ];
    if(profile_dict == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    Profile* profile = [Profile makeProfileFromDict:profile_dict];
    
    NSMutableDictionary* userInfo= [[NSMutableDictionary alloc] init];
    [userInfo setObject:_profileId forKey:@"profileId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotProfile" object:profile userInfo:userInfo];
}

@end
