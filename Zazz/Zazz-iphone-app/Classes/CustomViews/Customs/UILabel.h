//
//  UILabel+fydo.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/23/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (fydo)
-(UILabel*)resizeWithFlexibleHeight;
@end


@implementation UILabel (fydo)
-(UILabel*)resizeWithFlexibleHeight{
    [self setNumberOfLines:0];
    CGSize size = [self frameForText:self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, self.frame.size.height) lineBreakMode:self.lineBreakMode];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height)];
    [self sizeToFit];
    [self setFrame:CGRectMake( CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    return self;
}

-(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode  {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary * attributes = @{NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
    
    
    CGRect textRect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    //Contains both width & height ... Needed: The height
    return textRect.size;
}
@end