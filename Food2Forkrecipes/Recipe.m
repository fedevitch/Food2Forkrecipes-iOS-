//
//  Recipe.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 19.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface Recipe()

@end

@implementation Recipe

@synthesize itemImageLink;
@synthesize titleRecipe;
@synthesize item_f2f_link;
@synthesize item_source_url;
@synthesize item_social_rank;
@synthesize item_publisher_url;
@synthesize item_publisher;
@synthesize ingredients;

-(void)listInitialize{
    NSLog(@"Recipe: init recipe");
    self.titleRecipe = [[NSString alloc] init];
    self.item_f2f_link = [[NSString alloc] init];
    self.item_publisher = [[NSString alloc] init];
    self.item_publisher_url = [[NSString alloc] init];
    self.item_social_rank = [[NSString alloc] init];
    self.item_source_url = [[NSString alloc] init];
    self.itemImageLink = [[NSString alloc] init];
    self.ingredients = [[NSMutableArray alloc] init];
}

@end