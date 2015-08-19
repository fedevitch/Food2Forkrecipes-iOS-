//
//  ViewController.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/5/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayRecipeController.h"
#import "RecipesList.h"
#import "RecipesListQuery.h"


@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,InterfaceAcess>

//controls
@property (strong, nonatomic) IBOutlet UITableView *recipesDisplayTable;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *displayTypeChanger;

@property (strong, nonatomic) NSString *choosedId;

//data containers for list
@property (strong, nonatomic) NSDictionary *queryResponse;//move
@property (strong, nonatomic) NSMutableArray *titlesList;
@property (strong, nonatomic) NSMutableArray *imagesList;
@property (strong, nonatomic) NSMutableArray *publisher;
@property (strong, nonatomic) NSMutableArray *social_rank;
@property (strong, nonatomic) NSMutableArray *recipe_id;
@property (strong, nonatomic) NSMutableArray *publisher_url;
@property (strong, nonatomic) NSMutableArray *source_url;
@property (strong, nonatomic) NSMutableArray *f2f_url;

@property (strong, nonatomic) RecipesList *recipesList;

@end

