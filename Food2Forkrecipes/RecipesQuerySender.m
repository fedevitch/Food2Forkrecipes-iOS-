//
//  RecipesQuerySender.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/7/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipesQuerySender.h"
//#import "AFHTTPRequestOperation.h"
//#import "UIImageView+AFNetworking.h"
@interface RecipesQuerySender()


@end





@implementation RecipesQuerySender
/*
static NSString * const baseURL = @"http://food2fork.com/api/";
//1 - trending
//2 - top rated
//3 - search

@synthesize queryResponse;

int recipesCount = 0;

-(int)getCount
{
    return recipesCount;
}

+(void)initialize{
    
}

-(void)sendQuery:(int)queryType SearchQuery:(NSString*)Query
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=31a6f30afb8d54d0e8f54b624e200e47&sort=t",baseURL]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.queryResponse = [NSJSONSerialization
                        JSONObjectWithData:responseObject
                        options:NSJSONReadingMutableContainers
                        error:nil];
               [self requestSuccessfull];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    
    [operation start];
    
}

-(void) requestSuccessfull
{
    NSLog(@"Query success. Count: %@",self.queryResponse[@"count"]);
    recipesCount = (int)[self.queryResponse[@"count"] integerValue];
    
    NSArray *recipesList = self.queryResponse[@"recipes"];
    int index = 0;
    
    self.titlesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.imagesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.publisher = [[NSMutableArray alloc] initWithObjects: nil];
    self.social_rank = [[NSMutableArray alloc] initWithObjects: nil];
    for(NSDictionary *element in recipesList){
        NSLog(@"index %i", index+1);
        
        //NSLog(@"f2f_url: %@",element[@"f2f_url"]);
        //NSLog(@"image_url: %@",element[@"image_url"]);
        
        [self.titlesList addObject:element[@"title"]];
        [self.imagesList addObject:element[@"image_url"]];
        [self.publisher addObject:element[@"publisher"]];
        [self.social_rank addObject:element[@"social_rank"]];
        NSLog(@"Title: %@",self.titlesList[index]);
        NSLog(@"Image: %@",self.imagesList[index]);
        NSLog(@"publisher: %@",self.publisher[index]);
        NSLog(@"rank: %@",self.social_rank[index]);
        
        
        
    }

}
*/

@end