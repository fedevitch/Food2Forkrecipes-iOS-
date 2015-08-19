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
    
    NSDictionary* recipeDetails = self.queryResponse[@"recipe"];
    [self.responseRecipe listInitialize];
    self.responseRecipe.titleRecipe = [recipeDetails[@"title"] stringByDecodingHTMLEntities];
    self.responseRecipe.itemImageLink = recipeDetails[@"image_url"];
    self.responseRecipe.item_publisher = recipeDetails[@"publisher"];
    self.responseRecipe.item_publisher_url = recipeDetails[@"publisher_url"];
    self.responseRecipe.item_source_url = recipeDetails[@"source_url"];
    //self.responseRecipe.item_social_rank = [[NSString alloc] init];//with initWithString app crashes on this one
    self.responseRecipe.item_social_rank = recipeDetails[@"social_rank"];
    for (NSString* ingredient in recipeDetails[@"ingredients"]) {
        if ([ingredient  isEqual: @""]) {
            NSLog(@"empty string found");
            continue;
        }
        [self.responseRecipe.ingredients addObject:[NSString stringWithFormat:@"%@",[ingredient stringByDecodingHTMLEntities]]];
    }
    [self.delegate displayRecipe];
    //    NSLog(@"title: %@",recipeDetails[@"title"]);
    //    NSLog(@"title: %@",self.titleRecipe);
    //    NSLog(@"rank: %@",self.item_social_rank);
    //    NSLog(@"publisher: %@",self.item_publisher);
    //    NSLog(@"image: %@",self.itemImageLink);
    //    NSLog(@"ingredients: %@",self.textRecipe);
    //    NSLog(@"publisher_url: %@",self.item_publisher_url);
    //    NSLog(@"source: %@",self.item_source_url);
}

@end