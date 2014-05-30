//
//  ZazzCategory.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 5/29/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ZazzCategory.h"
#import "Category.h"

@implementation ZazzCategory


-(void)getCategoriesDelegate:(id)delegate{
    [self set_delegate:delegate];
    receivedData = [[NSMutableData alloc] init];
    
    NSString * api_action =  [[ZazzApi BASE_URL] stringByAppendingString:@"categories"];
    NSString * token_bearer = [NSString stringWithFormat:@"Bearer %@", [delegate auth_token]];
    //define request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: api_action ]];
    [request setValue: token_bearer forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];

    [NSURLConnection connectionWithRequest:request delegate:self];
}


NSMutableData* receivedData;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil ];
    if(array == nil){
        NSLog(@"JSON ERROR");
        return;
    }
    
    NSMutableArray *categoryList = [[NSMutableArray alloc] init];
    
    for(NSDictionary* cat_dict in array) {
        ZCategory* category = [[ZCategory alloc ] init];
        [category setCategory_id:[cat_dict objectForKey:@"id"]];
        [category setName:[cat_dict objectForKey:@"name"]];
        [categoryList addObject:category];
    }
    
    [self._delegate gotCategories:categoryList];
}

@end
