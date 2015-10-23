//
//  Recipe.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 19.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#ifndef Food2Forkrecipes_Recipe_h
#define Food2Forkrecipes_Recipe_h


#endif

#import "JSONModel/JSONModel.h"

@interface recipe:JSONModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *f2f_url;
@property (strong, nonatomic) NSString *source_url;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *publisher_url;
@property (strong, nonatomic) NSString *social_rank;
@property (strong, nonatomic) NSArray *ingredients;

@end

@protocol Recipe
@end

@interface RecipeDetails : JSONModel

@property (strong, nonatomic) NSDictionary<Recipe> *recipe;

-(void)initWithNil;

@end