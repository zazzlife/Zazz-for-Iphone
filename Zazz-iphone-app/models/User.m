//
//  Profile.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/10/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "User.h"
#import "SDWebImageManager.h"

@implementation User

@synthesize userId;
@synthesize is_public;
@synthesize accountType;
@synthesize isConfirmed;
@synthesize username;
@synthesize photoUrl;
@synthesize image;

-(User*)init{
    if (self = [super init])
        self.is_public = false;
    return self;
}
//
//-(NSString*)photoUrl{
//    return self.photoUrl;
//}
//-(void)setPhotoUrl:(NSString *)photoUrl{
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    User *profile = self;
//    [manager downloadWithURL:[NSURL URLWithString:photoUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
//         if (image){
//             [profile setImage:image];
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotMe" object:profile userInfo:nil];
//         }
//     }];
//}

+(User*)makeUserFormDict:(NSDictionary*)user_dict{
    User* profile = [[User alloc] init];
    [profile setUserId:[user_dict objectForKey:@"userId"]];
    [profile setAccountType:[user_dict objectForKey:@"accountType"]];
    [profile setIsConfirmed:(BOOL)[user_dict objectForKey:@"isConfirmed"]];
    [profile setUsername:[user_dict objectForKey:@"displayName"]];
    [profile setPhotoUrl:[[user_dict objectForKey:@"displayPhoto"] objectForKey:@"mediumLink"]];
    return profile;
}

@end
