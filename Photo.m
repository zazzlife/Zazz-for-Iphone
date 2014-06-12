//
//  Photo.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/18/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "Photo.h"
#import "SDWebImageManager.h"

@implementation Photo

@synthesize photoId;
@synthesize albumId;
@synthesize description;
@synthesize user;
@synthesize image;
@synthesize categories;


-(NSString*)photoUrl{
    return self.photoUrl;
}

-(void)setPhotoUrl:(NSString *)photoUrl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block Photo *photo = self;
    [manager downloadWithURL:[NSURL URLWithString:photoUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){} completed:^(UIImage *dlImage, NSError *error, SDImageCacheType cacheType, BOOL finished){
        if (dlImage){
            [photo setImage:dlImage];
            NSDictionary* userInfo = [NSDictionary dictionaryWithObject:photo forKey:@"photo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotPhotoImage" object:nil userInfo:userInfo];
        }
    }];
}


@end
