//
//  Recipe.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 19.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeDetails.h"

@implementation recipe

@synthesize title;
@synthesize social_rank;
@synthesize source_url;
@synthesize publisher;
@synthesize publisher_url;
@synthesize f2f_url;
@synthesize image_url;
@synthesize ingredients;

@end

@interface RecipeDetails()

@end

@implementation RecipeDetails

@synthesize recipe;


-(void)initWithNil{
    NSLog(@"Recipe: init recipe");
    
}

@end