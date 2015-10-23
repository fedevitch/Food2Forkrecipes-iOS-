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
//#import "MWFeedParser/Classes/NSString+HTML.h"




@interface DisplayRecipeController()

@end

@implementation DisplayRecipeController

static NSString * const baseURL = @"http://food2fork.com/api/";
static NSString * const apiKey = @"31a6f30afb8d54d0e8f54b624e200e47";
RecipeDetailsQuery *detailsRecipe;
NSString *publisherURL, *sourceURL, *imgURL;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    NSLog(@"display details init");
    self.recipe = [[RecipeDetails alloc] init];
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
    NSLog(@"Getting item. ID:%@", self.recipeId);
    self.recipe = detailsRecipe.responseRecipe;
    NSLog(@"Display details -> received recipe: %@",self.recipe);
    self.title = [self.recipe.recipe objectForKey:@[@"title"]];

    [self.Subtitle setText: [NSString stringWithFormat:@"publisher: %@ rank: %@",self.recipe.recipe[@"publisher"], self.recipe.recipe[@"social_rank"]]];
    NSLog(@"тайтл і футер вивів");
    self.navigationController.navigationBar.topItem.title = self.recipe.recipe[@"title"];


    //self.Text.text = [self parseHtmlCodes:Recipe];
    NSString *txt = @"";
    
    for (NSString *item in self.recipe.recipe[@"ingredients"]) {
        txt = [NSString stringWithFormat:@"%@\n%@",txt,item];
        //NSLog(@"%@",txt);

    }
    self.Text.text = txt;
    
    NSLog(@"майже все вивів");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.recipe.recipe[@"image_url"]]];
    
    __weak UIImageView *ImagePlaceholder = self.ItemImage;
    
    [self.ItemImage setImageWithURLRequest:request
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                
                                ImagePlaceholder.image = image;
                                
                            } failure:nil];
    publisherURL = self.recipe.recipe[@"publisher_url"];
    sourceURL = self.recipe.recipe[@"source_url"];
    imgURL = self.recipe.recipe[@"image_url"];
    NSLog(@"товаг'іщі! вивад акончєн!");
}

-(IBAction)viewSource
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sourceURL]];
}

-(IBAction)viewPublisher
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:publisherURL]];
}

-(IBAction)viewImage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:imgURL]];
}

@end
