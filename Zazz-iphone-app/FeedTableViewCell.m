//
//  FeedTableViewCell.m
//  Zazz-iphone-app
//
//  Created by Mitchell Sorkin on 5/7/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "ZazzApi.h"
#import "Photo.h"
#import "Profile.h"
#import "Event.h"
#import "Post.h"
#import "UIImage.h"

@implementation FeedTableViewCell

@synthesize tableView;
@synthesize feedCellBackgroundView;
@synthesize feedCellContentView;
@synthesize userImage;
@synthesize timestamp;
@synthesize username;

float CELL_HEIGHT = 150;
float HEADER_HEIGHT = 60;
float CONTENT_PADDING_BOTTOM = 10;
float TEXT_CONTENT_PADDING = 10;
float CELL_PADDING = 5;


-(void)resizeHeightForLabel: (UILabel*)label {
    label.numberOfLines = 0;
    UIView *superview = label.superview;
    [label removeFromSuperview];
    [label removeConstraints:label.constraints];
    CGRect labelFrame = label.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect expectedFrame = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, 9999)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 label.font, NSFontAttributeName,
                                                                 nil]
                                                        context:nil];
        labelFrame.size = expectedFrame.size;
        labelFrame.size.height = ceil(labelFrame.size.height); //iOS7 is not rounding up to the nearest whole number
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        labelFrame.size = [label.text sizeWithFont:label.font
                                 constrainedToSize:CGSizeMake(label.frame.size.width, 9999)
                                     lineBreakMode:label.lineBreakMode];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    label.frame = labelFrame;
    [superview addSubview:label];
}


-(void)setFeed:(Feed *)feed{
    [self.userImage setImage:feed.user.photo];
    [self.username setText:feed.user.username];
    [self.timestamp setText:feed.timestamp];
    [self setNeeded_height:HEADER_HEIGHT];
    [self.feedCellBackgroundView setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, self.tableView.frame.size.width - (2*CELL_PADDING), self.needed_height)];
    [self.feedCellContentView setFrame:CGRectMake(0, HEADER_HEIGHT, self.feedCellBackgroundView.frame.size.width, 0)];
    for(UIView* view in self.feedCellContentView.subviews){
        [view removeFromSuperview];
    }
    
    if([[feed feedType] isEqualToString:@"Photo"]){
        for(Photo* photo in (NSMutableArray*)[feed content]){
            UIImage* image = [UIImage getImage:photo.photo scaledToWidth:self.tableView.frame.size.width];
            UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
            [self.feedCellContentView addSubview:imageView];
            self.needed_height += imageView.image.size.height;
        }
        self.needed_height += CONTENT_PADDING_BOTTOM;
    }else{
        NSString* text = @"";
        if([[feed feedType] isEqualToString:@"Post"]){
            text = [(Post*)[feed content] message];
        }else if([[feed feedType] isEqualToString:@"Event"]){
            text = [(Event*)[feed content] description];
        }
        CGRect label_frame = CGRectMake(TEXT_CONTENT_PADDING, 0, self.feedCellContentView.frame.size.width-(2*TEXT_CONTENT_PADDING), 0);
        UILabel* label = [[UILabel alloc] initWithFrame:label_frame];
        [label setText:text];
        [self resizeHeightForLabel:label];
        [self.feedCellContentView addSubview:label];
        self.needed_height += label.frame.size.height + CONTENT_PADDING_BOTTOM;
    }
    [self.feedCellContentView sizeToFit];
    [self.feedCellBackgroundView.layer setCornerRadius:5];
    [self.feedCellBackgroundView.layer setMasksToBounds:YES];
    [self.userImage.layer setCornerRadius:25];
    [self.userImage.layer setMasksToBounds:YES];
    [self.feedCellBackgroundView setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, self.tableView.frame.size.width - (2*CELL_PADDING), self.needed_height)];
    self.needed_height += CELL_PADDING;
}

@end
