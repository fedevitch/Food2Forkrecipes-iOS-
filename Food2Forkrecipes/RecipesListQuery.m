//
//  RecipesListQuery.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 19.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RecipesListQuery.h"
#import "AFHTTPRequestOperation.h"
#import "MWFeedParser/Classes/NSString+HTML.h"
@interface RecipesListQuery()

@end

@implementation RecipesListQuery

//1 - trending
//2 - top rated
//3 - search

static int const Trending = 1;
static int const TopRated = 2;
static int const Search = 3;

static NSString * const baseURL = @"http://food2fork.com/api/";
static NSString * const apiKey = @"31a6f30afb8d54d0e8f54b624e200e47";

-(void)sendQuery: (int)queryType SearchQuery:(NSString*)Query page:(int)page
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=t",baseURL,apiKey]];//default value
    if (queryType == Trending) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=t&page=%i",baseURL,apiKey,page]];

        
    }
    if (queryType == TopRated) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=r&page=%i",baseURL,apiKey,page]];

        
    }
    if (queryType == Search) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&q=%@&page=%i",baseURL,apiKey,Query,page]];
    }
    
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
        //using alertview
        NSString *message = [NSString stringWithFormat:@"error:  %@",[error localizedDescription] ];
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        int duration = 1; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }];
    [operation start];
}

-(void) requestSuccessfull
{
    [self.responseList initWithNil];
    self.responseList = [[RecipesList alloc] initWithDictionary:self.queryResponse error:nil];
    NSLog(@"received:%@",[[self.responseList.recipes objectAtIndex:0] title]);
    [self.delegate tableReloadData];
}

@end