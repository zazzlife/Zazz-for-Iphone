//
//  ZazzFollow.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/13/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZazzFollow : NSObject

@property NSMutableData* _receivedData;
-(void)getFollows;

@end
