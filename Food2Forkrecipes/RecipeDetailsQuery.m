//
//  RecipeDetailsQuery.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 19.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeDetailsQuery.h"

#import "AFHTTPRequestOperation.h"
#import "MWFeedParser/Classes/NSString+HTML.h"

@class RecipeDetailsQuery;

@interface RecipeDetailsQuery()

@end

@implementation RecipeDetailsQuery

static NSString * const baseURL = @"http://food2fork.com/api/";
static NSString * const apiKey = @"31a6f30afb8d54d0e8f54b624e200e47";

-(void)getRecipe:(NSString*)recipeId
{
    self.responseRecipe = [[Recipe alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@get?key=%@&rId=%@",baseURL,apiKey,recipeId]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.queryResponse = [NSJSONSerialization
                                 JSONObjectWithData:responseObject
                                 options:NSJSONReadingMutableContainers
                                 error:nil];
        [self successfull];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    
    [operation start];

}

-(void)successfull
{
    NSLog(@"Get recipe: Query success =^_^=");
    self.responseRecipe = [[Recipe alloc] initWithDictionary:self.queryResponse error:nil];
    [self.delegate displayRecipe];

}

@end