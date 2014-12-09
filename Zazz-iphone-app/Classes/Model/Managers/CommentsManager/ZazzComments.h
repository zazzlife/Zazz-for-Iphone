//
//  ZazzComments.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 7/16/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZazzComments : NSObject

-(void)getCommentsFor:(NSString*)feedType andId:(NSString*)feedId;
-(void)getCommentsFor:(NSString*)feedType andId:(NSString*)feedId after:(NSString*)commentId;

@end
