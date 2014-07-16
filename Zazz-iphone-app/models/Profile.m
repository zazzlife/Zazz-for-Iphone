//
//  Profile.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Profile.h"
#import "SDWebImageManager.h"

@implementation Profile

@synthesize userId;
@synthesize is_public;
@synthesize accountType;
@synthesize isConfirmed;
@synthesize username;
@synthesize photo;

-(Profile*)init{
    if (self = [super init])
        self.is_public = false;
    return self;
}

-(NSString*)photoUrl{
    return self.photoUrl;
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block Profile *profile = self;
    [manager downloadWithURL:[NSURL URLWithString:photoUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
         if (image){
             [profile setPhoto:image];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotProfile" object:profile userInfo:nil];
         }
     }];
}

+(Profile*)makeProfileFromDict:(NSDictionary*)profile_dict{
    Profile* profile = [[Profile alloc] init];
    [profile setUserId:[profile_dict objectForKey:@"userId"]];
    [profile setAccountType:[profile_dict objectForKey:@"accountType"]];
    [profile setIsConfirmed:(BOOL)[profile_dict objectForKey:@"isConfirmed"]];
    [profile setUsername:[profile_dict objectForKey:@"displayName"]];
    [profile setPhotoUrl:[[profile_dict objectForKey:@"displayPhoto"] objectForKey:@"mediumLink"]];
    return profile;
}

@end
