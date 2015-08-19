//
//  RecipesList.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 14.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipesList.h"

@interface RecipesList()


@end

@implementation RecipesList

@synthesize titlesList;
@synthesize imagesList;
@synthesize publisher;
@synthesize publisher_url;
@synthesize social_rank;
@synthesize recipe_id;
@synthesize source_url;
@synthesize count;

-(void)listInitialize{
    NSLog(@"listsInitialize: doing alloc-initWithObjects: nil for lists");
    self.count = 0;
    self.titlesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.imagesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.publisher = [[NSMutableArray alloc] initWithObjects: nil];
    self.social_rank = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipe_id = [[NSMutableArray alloc] initWithObjects: nil];
    self.publisher_url = [[NSMutableArray alloc] initWithObjects: nil];
    self.source_url = [[NSMutableArray alloc] initWithObjects: nil];
}

-(void)addDataFromAnotherRecipesList:(RecipesList *)anotherList{
    NSLog(@"Add: updating list");
    self.count += anotherList.count;
    for (int i = 0; i < anotherList.count; i++) {
        //NSLog(@"Add: element%i",i);
        [self.titlesList addObject:anotherList.titlesList[i]];
        [self.imagesList addObject:anotherList.imagesList[i]];
        [self.publisher addObject:anotherList.publisher[i]];
        [self.publisher_url addObject:anotherList.publisher_url[i]];
        [self.recipe_id addObject:anotherList.recipe_id[i]];
        [self.social_rank addObject:anotherList.social_rank[i]];
        [self.source_url addObject:anotherList.source_url[i]];
    }
}


@end