//
//  ZazzMe.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/9/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzProfile.h"
#import "UIImage.h"

@implementation ZazzProfile

NSString* _profileId;

- (void) getMyProfile{
    _profileId = @"";
    NSString * action = @"me";
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:action];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void) getProfile:(NSString *)userId{
    _profileId = userId;
    NSLog(@"TODO; IMPLEMENT GET PROFILE WITH USERID - ZazzProfile:getProfile");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    Profile* profile = [Profile makeProfileFromDict:array];
    
    NSMutableDictionary* userInfo= [[NSMutableDictionary alloc] init];
    [userInfo setObject:_profileId forKey:@"profileId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotProfile" object:profile userInfo:userInfo];
}

@end
