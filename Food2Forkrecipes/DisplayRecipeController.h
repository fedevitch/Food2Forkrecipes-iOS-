//
//  DisplayRecipeController.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/11/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayRecipeController : UIViewController

//controls
@property (strong, nonatomic) IBOutlet UINavigationBar *NavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *ItemImage;
@property (strong, nonatomic) IBOutlet UITextView *Text;



@property (nonatomic) NSString* recipeId;

//data containers for recipe
@property (strong, nonatomic) NSDictionary *queryResponseGet;
@property (strong, nonatomic) NSString *titleRecipe;
@property (strong, nonatomic) NSMutableArray *textRecipe;
@property (strong, nonatomic) NSString *itemImageLink;
@property (strong, nonatomic) NSString *item_f2f_link;
@property (strong, nonatomic) NSString *item_source_url;
@property (strong, nonatomic) NSString *item_publisher;
@property (strong, nonatomic) NSString *item_publisher_url;
@property (strong, nonatomic) NSString *item_social_rank;

@end
