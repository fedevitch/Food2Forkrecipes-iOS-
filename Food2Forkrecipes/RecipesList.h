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

@interface RecipesList:NSObject

@property (strong, nonatomic) NSMutableArray *titlesList;
@property (strong, nonatomic) NSMutableArray *imagesList;
@property (strong, nonatomic) NSMutableArray *publisher;
@property (strong, nonatomic) NSMutableArray *social_rank;
@property (strong, nonatomic) NSMutableArray *recipe_id;
@property (strong, nonatomic) NSMutableArray *publisher_url;
@property (strong, nonatomic) NSMutableArray *source_url;
@property (strong, nonatomic) NSMutableArray *f2f_url;

@end