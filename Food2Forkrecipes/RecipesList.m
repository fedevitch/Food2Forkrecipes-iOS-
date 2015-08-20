//
//  RecipesList.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 14.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipesList.h"
#import "JSONModel/JSONModelLib.h"

@implementation recipes_list

@synthesize title;
@synthesize image_url;
@synthesize publisher;
@synthesize publisher_url;
@synthesize social_rank;
@synthesize source_url;
@synthesize recipe_id;
@synthesize f2f_url;

@end

@interface RecipesList()

@end

@implementation RecipesList

@synthesize count;
@synthesize recipes;

-(void)initWithNil{
    NSLog(@"listsInitialize: doing alloc-initWithObjects: nil for lists");
    self.count = 0;
    [self.recipes removeAllObjects];
    self.recipes = (id)[NSMutableArray new];
}

-(void)addDataFromAnotherRecipesList:(RecipesList *)anotherList{
    NSLog(@"Add: updating list with another: title of 0: %@",[[anotherList.recipes objectAtIndex:0] title]);
    self.count += anotherList.count;    
    [self.recipes addObjectsFromArray:anotherList.recipes];
}


@end