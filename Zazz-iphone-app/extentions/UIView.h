//
//  UIView+fydo.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/25/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (fydo)

-(BOOL)hasSubviews;
-(void)removeAllSubviews;
-(UIView*)subviewWithRestorationIdentifier:(NSString*)identifier;
-(UIView*)firstSubviewWithTag:(int)tag;

@end


@implementation UIView (fydo)

-(BOOL)hasSubviews{
    return [[self subviews] count] > 0;
}

-(void)removeAllSubviews{
    for(UIView* subview in self.subviews){
        [subview removeFromSuperview];
    }
}
-(UIView*)subviewWithRestorationIdentifier:(NSString*)identifier{
    for(UIView* view in self.subviews){
        if([view.restorationIdentifier isEqualToString:identifier])
            return view;
    }
    return nil;
}

-(UIView*)firstSubviewWithTag:(int)tag{
    for(UIView* view in self.subviews){
        if(view.tag == tag)
            return view;
    }
    return nil;
}

@end

