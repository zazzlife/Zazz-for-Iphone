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

@synthesize profile_id;
@synthesize accountType;
@synthesize displayName;
//@synthesize photoUrl;
@synthesize image;
@synthesize followersCount;
@synthesize feeds;
@synthesize photos;
@synthesize weeklies;
@synthesize userDetails;
//@property ClubDetails* clubDetails;
@synthesize followRequestAlreadySent;
@synthesize isSelf;
@synthesize isCurrentUserFollowingTargetUser;
@synthesize isTargetUserFollowingCurrentUser;

-(NSString*)photoUrl{
    return self.photoUrl;
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block Profile *profile = self;
    [manager downloadWithURL:[NSURL URLWithString:photoUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
         if (image){
             [profile setImage:image];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotProfile" object:profile userInfo:nil];
         }
     }];
}

+(Profile*)makeProfileFromDict:(NSDictionary*)profile_dict{
    Profile* profile = [[Profile alloc] init];
    
    [profile setProfile_id:[profile_dict objectForKey:@"userId"]];
    [profile setAccountType:[profile_dict objectForKey:@"accountType"]];
    [profile setDisplayName:[profile_dict objectForKey:@"displayName"]];
    [profile setFollowersCount:(int)[profile_dict objectForKey:@"followersCount"]];
    [profile setFollowRequestAlreadySent:(BOOL)[profile_dict objectForKey:@"followRequestAlreadySent"]];
    [profile setIsSelf:(BOOL)[profile_dict objectForKey:@"isSelf"]];
    [profile setIsCurrentUserFollowingTargetUser:(BOOL)[profile_dict objectForKey:@"isCurrentUserFollowingTargetUser"]];
    [profile setIsTargetUserFollowingCurrentUser:(BOOL)[profile_dict objectForKey:@"isTargetUserFollowingCurrentUser"]];
    if([profile.accountType isEqualToString:@"User"]){
        [profile setUserDetails:[UserDetails makeUserDetailsFromDict:[profile_dict objectForKey:@"userDetails"]]];
    }
    [profile setPhotoUrl:[[profile_dict objectForKey:@"displayPhoto"] objectForKey:@"mediumLink"]];
    return profile;
}

@end
