//
//  DisplayRecipeController.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/11/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "RecipeDetailsQuery.h"

@class DisplayRecipeController;

//@protocol ReturnBack <NSObject>
//
//-(void)returnBack: (DisplayRecipeController *)displayRecipe isReturn:(BOOL)isReturning recipesList:(RecipesList *)savedList;
//
//@end

@interface DisplayRecipeController : UIViewController<displayResult>

//controls
//@property (strong, nonatomic) IBOutlet UINavigationBar *NavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *ItemImage;
@property (strong, nonatomic) IBOutlet UITextView *Text;
@property (strong, nonatomic) IBOutlet UILabel *Subtitle;
@property (strong, nonatomic) IBOutlet UIButton *viewSourceButton;
@property (strong, nonatomic) IBOutlet UIButton *viewPublisherButton;
@property (strong, nonatomic) IBOutlet UIButton *viewImageButton;



@property (nonatomic) NSString* recipeId;

//data containers for recipe
@property (strong, nonatomic) NSDictionary *queryResponseGet;
//@property (strong, nonatomic) NSString *titleRecipe;
//@property (strong, nonatomic) NSMutableArray *textRecipe;
//@property (strong, nonatomic) NSString *itemImageLink;
//@property (strong, nonatomic) NSString *item_f2f_link;
//@property (strong, nonatomic) NSString *item_source_url;
//@property (strong, nonatomic) NSString *item_publisher;
//@property (strong, nonatomic) NSString *item_publisher_url;
//@property (strong, nonatomic) NSString *item_social_rank;

@property (strong,nonatomic) Recipe *recipe;

//list must be saved!
//data containers for list
//@property RecipesList *listSaver;

//@property (weak,nonatomic) id <ReturnBack> delegate;

@end
