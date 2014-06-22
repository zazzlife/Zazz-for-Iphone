//
//  ZazzCategory.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzCategory.h"
#import "CategoryStat.h"

@implementation ZazzCategory

@synthesize _delegate;
@synthesize _receivedData;

-(void)getCategoriesDelegate:(id)delegate{
    [self set_delegate:delegate];
    NSMutableURLRequest* request = [ZazzApi getRequestWithAction:@"categoriesstat"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(!self._receivedData) self._receivedData = [[NSMutableData alloc]init];
    [self._receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:self._receivedData options:0 error:nil ];
    NSString* receivedDataString = [[NSString alloc] initWithData:self._receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",receivedDataString);
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray *categoryList = [[NSMutableArray alloc] init];
    
    for(NSDictionary* cat_dict in array) {
        CategoryStat* category = [[CategoryStat alloc ] init];
        [category setCategory_id:[cat_dict objectForKey:@"id"]];
        [category setName:[cat_dict objectForKey:@"name"]];
        [category setUserCount:[[cat_dict objectForKey:@"usersCount"] intValue]];
        [categoryList addObject:category];
    }
    
    [self._delegate gotCategories:categoryList];
}

@end
