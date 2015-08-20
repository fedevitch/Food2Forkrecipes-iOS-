//
//  RecipesList.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 14.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#ifndef Food2Forkrecipes_RecipesList_h
#define Food2Forkrecipes_RecipesList_h



#endif

#import "JSONModel/JSONModel.h"


@interface recipes_list:JSONModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *social_rank;
@property (strong, nonatomic) NSString *recipe_id;
@property (strong, nonatomic) NSString *publisher_url;
@property (strong, nonatomic) NSString *source_url;
@property (strong, nonatomic) NSString *f2f_url;

@end

@protocol recipes_list
@end

@interface RecipesList:JSONModel

@property (nonatomic) int count;
@property (strong, nonatomic) NSMutableArray<recipes_list> *recipes;

-(void)initWithNil;
-(void)addDataFromAnotherRecipesList: (RecipesList*)anotherList;

@end