//
//  UIView+fydo.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/25/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (fydo)

-(void)removeAllSubviews;

@end


@implementation UIView (fydo)

-(void)removeAllSubviews{
    for(UIView* subview in self.subviews){
        [subview removeFromSuperview];
    }
}
@end

