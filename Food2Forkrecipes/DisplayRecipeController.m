//
//  DisplayRecipeController.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/11/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//


#import "DisplayRecipeController.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "MWFeedParser/Classes/NSString+HTML.h"




@interface DisplayRecipeController()

@end

@implementation DisplayRecipeController

static NSString * const baseURL = @"http://food2fork.com/api/";
static NSString * const apiKey = @"31a6f30afb8d54d0e8f54b624e200e47";
RecipeDetailsQuery *detailsRecipe;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    NSLog(@"display details init");
    self.recipe = [[Recipe alloc] init];
    [self.recipe initWithNil];
    detailsRecipe = [[RecipeDetailsQuery alloc] init];
    detailsRecipe.delegate = self;
    [detailsRecipe getRecipe:self.recipeId];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue... id: %@", segue.identifier);
}


-(void) displayRecipe
{
    self.recipe = detailsRecipe.responseRecipe;
    self.navigationItem.title = [self.recipe.recipe objectForKey:@[@"title"]];
    self.title = [self.recipe.recipe objectForKey:@[@"title"]];

    [self.Subtitle setText: [NSString stringWithFormat:@"publisher: %@ rank: %@",[self.recipe.recipe objectForKey:@[@"publisher"]], [self.recipe.recipe objectForKey:@[@"social_rank"]]]];

    self.navigationController.navigationBar.topItem.title = [self.recipe.recipe objectForKey:@[@"title"]];

//    NSLog(@"text: %@",Recipe);
    //self.Text.text = [self parseHtmlCodes:Recipe];
    self.Text.text = [self.recipe.recipe objectForKey:@[@"ingredients"]];
    //for (int i = 0; i < [self.recipe.ingredients count]; i++) {
    //    self.Text.text = [NSString stringWithFormat:@"%@\n%@",[self.Text text],[self.recipe.recipe objectForKey:[@"ingredients"]];
    //}
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.recipe.recipe objectForKey:@[@"image_url"]]]];
    
    __weak UIImageView *ImagePlaceholder = self.ItemImage;
    
    [self.ItemImage setImageWithURLRequest:request
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                
                                ImagePlaceholder.image = image;
                                
                            } failure:nil];
    
}

-(IBAction)viewSource
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.recipe.recipe objectForKey:@[@"source_url"]]]];
}

-(IBAction)viewPublisher
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.recipe.recipe objectForKey:@[@"publisher_url"]]]];
}

-(IBAction)viewImage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.recipe.recipe objectForKey:@[@"image_url"]]]];
}

@end
