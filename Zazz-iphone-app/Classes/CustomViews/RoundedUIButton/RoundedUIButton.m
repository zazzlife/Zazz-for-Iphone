//
//  RoundedUIButton.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 8/13/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "RoundedUIButton.h"

@implementation RoundedUIButton

@synthesize radius;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    if(!self.radius) [self setRadius:5];
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

@end
