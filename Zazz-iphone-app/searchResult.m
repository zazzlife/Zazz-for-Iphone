//
//  searchResult.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 10/13/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult

@synthesize title;
@synthesize subTitle;
@synthesize imageUrl;
@synthesize is_selected;

+(SearchResult*)makeSearchResultFromUser:(NSMutableDictionary*)user_dict{
    SearchResult* result = [[SearchResult alloc] init];
    return result;
}
+(SearchResult*)makeSearchResultFromPlace:(NSMutableDictionary*)place_dict{
    SearchResult* result = [[SearchResult alloc] init];
    return result;
}

@end
