//
//  searchResult.h
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/13/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

@property NSString* title;
@property NSString* subTitle;
@property NSURL* imageUrl;
@property BOOL* is_selected;

+(SearchResult*)makeSearchResultFromUser:(NSMutableDictionary*)user_dict;
+(SearchResult*)makeSearchResultFromPlace:(NSMutableDictionary*)place_dict;

@end
