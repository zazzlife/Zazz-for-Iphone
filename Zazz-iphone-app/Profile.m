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
@synthesize accountType;
@synthesize isConfirmed;
@synthesize username;
@synthesize photo;

-(NSString*)photoUrl{
    return self.photoUrl;
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block Profile *profile = self;
    [manager downloadWithURL:[NSURL URLWithString:photoUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
         if (image){
             [profile setPhoto:image];
             NSDictionary* userInfo = [NSDictionary dictionaryWithObject:profile forKey:@"profile"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotProfilePhoto" object:nil userInfo:userInfo];
             
         }
     }];
}

@end
