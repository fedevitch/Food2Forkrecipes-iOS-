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

@interface Recipe : NSObject

@property (strong, nonatomic) NSDictionary *queryResponseGet;
@property (strong, nonatomic) NSString *titleRecipe;
@property (strong, nonatomic) NSString *itemImageLink;
@property (strong, nonatomic) NSString *item_f2f_link;
@property (strong, nonatomic) NSString *item_source_url;
@property (strong, nonatomic) NSString *item_publisher;
@property (strong, nonatomic) NSString *item_publisher_url;
@property (strong, nonatomic) NSString *item_social_rank;
@property (strong, nonatomic) NSMutableArray *ingredients;

-(void)listInitialize;

@end