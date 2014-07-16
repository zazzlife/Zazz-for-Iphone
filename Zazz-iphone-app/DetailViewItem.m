//
//  DetailViewItem.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/15/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "DetailViewItem.h"
#import "Comment.h"

@implementation DetailViewItem

const int TYPE_POST = 0;
const int TYPE_PHOTO = 1;
const int TYPE_EVENT = 2;

@synthesize type;

-(NSString*)typeToString{
    switch(self.type){
        case TYPE_POST:
            return COMMENT_TYPE_POST;
        case TYPE_PHOTO:
            return COMMENT_TYPE_PHOTO;
        case TYPE_EVENT:
        default:
            return COMMENT_TYPE_EVENT;
    }
}

@end
