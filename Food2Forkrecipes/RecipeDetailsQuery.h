//
//  RecipeDetailsQuery.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 19.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#ifndef Food2Forkrecipes_RecipeDetailsQuery_h
#define Food2Forkrecipes_RecipeDetailsQuery_h


#endif

#import "RecipeDetails.h"

@class RecipeDetailsQuery;

@protocol displayResult <NSObject>

-(void) displayRecipe;

@end

@interface RecipeDetailsQuery : NSObject


@property (strong, nonatomic) NSDictionary *queryResponse;
@property (strong, nonatomic) RecipeDetails *responseRecipe;
-(void)getRecipe:(NSString*)recipeId;

@property (weak, nonatomic) id <displayResult> delegate;

@end