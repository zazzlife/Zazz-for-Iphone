//
//  CGSize+frameForText.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/22/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//


@interface TextFramer : NSObject
    +(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end


