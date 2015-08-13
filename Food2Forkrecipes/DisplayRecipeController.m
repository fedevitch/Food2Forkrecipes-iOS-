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
#import "PhotoViewController.h"

@implementation DisplayRecipeController

static NSString * const baseURL = @"http://food2fork.com/api/";
static NSString * const apiKey = @"31a6f30afb8d54d0e8f54b624e200e47";

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"display details init");
    [self getRecipe:self.recipeId];
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//}

-(void)getRecipe:(NSString*)recipeId
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@get?key=%@&rId=%@",baseURL,apiKey,recipeId]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.queryResponseGet = [NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:NSJSONReadingMutableContainers
                              error:nil];
        [self recipeRequestSuccessfull];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    
    [operation start];
}

-(void) recipeRequestSuccessfull
{
    NSLog(@"Get recipe: Query success =^_^= ID:%@",self.recipeId);
    NSDictionary* recipeDetails = self.queryResponseGet[@"recipe"];
    
    self.textRecipe = [[NSMutableArray alloc] initWithObjects:recipeDetails[@"ingredients"],nil];
    self.titleRecipe = [[NSString alloc] initWithString:recipeDetails[@"title"]];
    self.itemImageLink = [[NSString alloc] initWithString:recipeDetails[@"image_url"]];
    self.item_publisher = [[NSString alloc] initWithString:recipeDetails[@"publisher"]];
    self.item_publisher_url = [[NSString alloc] initWithString:recipeDetails[@"publisher_url"]];
    self.item_source_url = [[NSString alloc] initWithString:recipeDetails[@"source_url"]];
    self.item_social_rank = [[NSString alloc] init];//with initWithString app crashes
    self.item_social_rank = recipeDetails[@"social_rank"];
    
//    NSLog(@"title: %@",recipeDetails[@"title"]);
//    NSLog(@"title: %@",self.titleRecipe);
//    NSLog(@"rank: %@",self.item_social_rank);
//    NSLog(@"publisher: %@",self.item_publisher);
//    NSLog(@"image: %@",self.itemImageLink);
//    NSLog(@"ingredients: %@",self.textRecipe);
//    NSLog(@"publisher_url: %@",self.item_publisher_url);
//    NSLog(@"source: %@",self.item_source_url);
    
    [self.Subtitle setText: [NSString stringWithFormat:@"publisher: %@ rank: %@",self.item_publisher, self.item_social_rank] ];

    
    NSString* Recipe = @"";

    for (NSDictionary* ingredient in recipeDetails[@"ingredients"]) {
        //NSLog(@"%@",ingredient);
        if ([ingredient  isEqual: @""]) {
            NSLog(@"empty string found");
            continue;
        }
        Recipe = [Recipe stringByAppendingString:[NSString stringWithFormat:@"%@\n",ingredient]];
    }

    self.navigationController.navigationBar.topItem.title = self.titleRecipe;

//    NSLog(@"text: %@",Recipe);
    //self.Text.text = [self parseHtmlCodes:Recipe];
    self.Text.text = Recipe;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.itemImageLink]];
    
    __weak UIImageView *ImagePlaceholder = self.ItemImage;
    
    [self.ItemImage setImageWithURLRequest:request
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                
                                ImagePlaceholder.image = image;
                                
                            } failure:nil];
    
}


-(NSString*)parseHtmlCodes:(NSString*)input { //this is a copy from ViewController
    //parse html codes (but not all)
    //source: http://stackoverflow.com/questions/1067652/converting-amp-to-in-objective-c
    NSRange rangeOfHTMLEntity = [input rangeOfString:@"&#"];
    if( NSNotFound == rangeOfHTMLEntity.location ) {
        NSRange amp = [input rangeOfString:@"&amp;"];// catch the '&'
        if (NSNotFound == amp.location) {
            return input;
        }
        else{
            input = [input stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
        return input;
    }
    
    
    NSMutableString* answer = [[NSMutableString alloc] init];
    //[answer autorelease];
    
    NSScanner* scanner = [NSScanner scannerWithString:input];
    [scanner setCharactersToBeSkipped:nil]; // we want all white-space
    
    while( ![scanner isAtEnd] ) {
        
        NSString* fragment;
        [scanner scanUpToString:@"&#" intoString:&fragment];
        if( nil != fragment ) { // e.g. '&#38; B'
            [answer appendString:fragment];
        }
        
        if( ![scanner isAtEnd] ) { // implicitly we scanned to the next '&#'
            
            int scanLocation = (int)[scanner scanLocation];
            [scanner setScanLocation:scanLocation+2]; // skip over '&#'
            
            int htmlCode;
            if( [scanner scanInt:&htmlCode] ) {
                char c = htmlCode;
                [answer appendFormat:@"%c", c];
                
                scanLocation = (int)[scanner scanLocation];
                [scanner setScanLocation:scanLocation+1]; // skip over ';'
                
            } else {
                // err ?
            }
        }
        
    }
    
    return answer;
    
}

-(IBAction)viewSource
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item_source_url]];
}

-(IBAction)viewPublisher
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item_publisher_url]];
}

-(IBAction)viewImage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.itemImageLink]];
}

@end
