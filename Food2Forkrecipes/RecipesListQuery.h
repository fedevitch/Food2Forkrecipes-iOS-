//
//  RecipesListQuery.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 19.08.15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#ifndef Food2Forkrecipes_RecipesListQuery_h
#define Food2Forkrecipes_RecipesListQuery_h


#endif

#import "RecipesList.h"

@protocol InterfaceAcess <NSObject>

-(void)tableReloadData;

@end

@interface RecipesListQuery : NSObject

@property (strong, nonatomic) NSDictionary *queryResponse;
@property (strong, nonatomic) RecipesList *responseList;
-(void)sendQuery: (int)queryType SearchQuery:(NSString*)Query page:(int)page;

@property (weak, nonatomic) id <InterfaceAcess> delegate;

@end