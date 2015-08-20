//
//  ViewController.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/5/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import "ViewController.h"

#import "AFHTTPRequestOperation.h"
#import "UIImageView+AFNetworking.h"

//#import "HCSStarRatingView/HCSStarRatingView.h"
#import "MWFeedParser/Classes/NSString+HTML.h"


//@class RecipesList;

@interface ViewController ()


@end

@implementation ViewController

//RecipesList *recipesList;
bool isReturningBack = NO;

static int const cacheInterval = 60;

//1 - trending
//2 - top rated
//3 - search


static int const Trending = 1;
static int const TopRated = 2;
static int const Search = 3;

static NSString * const baseURL = @"http://food2fork.com/api/";
static NSString * const apiKey = @"31a6f30afb8d54d0e8f54b624e200e47";

int currentPage = 1;
int currentDisplayType = 1;

int selectedItem = 0;
NSString* choosedId;
bool updatingList = NO;
RecipesListQuery *listQuery;

//@synthesize recipesDisplayTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.recipesList = [[RecipesList alloc] init];
    
    self.recipesDisplayTable.delegate = self;
    self.recipesDisplayTable.dataSource = self;
    
    listQuery = [[RecipesListQuery alloc] init];
    listQuery.delegate = self;
    currentPage = 1;
    [self.recipesList initWithNil];
    [self sendQuery:Trending SearchQuery:@"" page:currentPage];
}

-(void)printLog{
    //NSLog(@"Log: current var state: %@",self.recipesList.recipe_id);
}

-(void)tableReloadData{
    //self.recipesList = listQuery.responseList;
    [self.recipesList addDataFromAnotherRecipesList:listQuery.responseList];
    NSLog(@"self.recipesList:%@",[self.recipesList.recipes objectAtIndex:0]);
    [self.recipesDisplayTable reloadData];
    //dispatch_async(dispatch_get_main_queue(), ^{[self.recipesDisplayTable reloadData];});
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue... id: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"showRecipe"]) {
        DisplayRecipeController *recipeDetails = (DisplayRecipeController*)segue.destinationViewController;
        recipeDetails.recipeId = [[self.recipesList.recipes objectAtIndex:selectedItem] recipeId];
        NSLog(@"Sending recipeId: %@",recipeDetails.recipeId);
    }
}

#pragma mark - Custom methods

-(int)getCount
{
    return self.recipesList.count;
}

-(RecipesList*)getRecipesList{
    return self.recipesList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Recipes";
    }
    return self;
}


-(void)sendQuery: (int)queryType SearchQuery:(NSString*)Query page:(int)page
{

    //[self.recipesDisplayTable setContentOffset:CGPointZero animated:YES];//scroll up tableview
    currentDisplayType = queryType;
    if (queryType == Search) {
        //self.navigationItem.title =[NSString stringWithFormat:@"Search results for: %@",Query ];
        [self.displayTypeChanger setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }
    [listQuery sendQuery:currentDisplayType SearchQuery:Query page:currentPage];
    [self.recipesDisplayTable reloadData];
}

#pragma mark - controls

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    [self.recipesDisplayTable setContentOffset:CGPointZero animated:YES];//scroll up tableview
        // set variables to default values
    [self.recipesList initWithNil];
    self.searchBar.text = @"";
    currentPage = 1;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        NSLog(@"switched to Top Rated");
        
        [self sendQuery:TopRated SearchQuery:@"" page:currentPage];
    }
    if (selectedSegment == 1){
        //toggle the correct view to be visible
        
        NSLog(@"switched to Trending");
        [self sendQuery:Trending SearchQuery:@"" page:currentPage];
     }
    [self.recipesDisplayTable reloadData];
}

/*
- (IBAction)previousButtonTouchUpInside:(id)sender {    //replaced with scroll
    NSLog(@"go back");
    currentPage -= 1;
    [self sendQuery:currentDisplayType SearchQuery:@"" page:currentPage];
}
- (IBAction)nextButtonTouchUpInside:(id)sender {        //replaced with scroll
    NSLog(@"go forward");
    currentPage += 1;
    [self sendQuery:currentDisplayType SearchQuery:@"" page:currentPage];
}
*/

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

    if ((!updatingList) && (maximumOffset - currentOffset <= 200.0)) {
        //using alertview
        NSString *message = @"pull down for more";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        int duration = 1; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    //    CGFloat minimumOffset = scroll.contentSize.height //for scroll up

    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 30.0) {
        // [self methodThatAddsDataAndReloadsTableView];
        NSLog(@"i want moar");
        currentPage += 1;
        updatingList = YES;
        [self sendQuery:currentDisplayType SearchQuery:@"" page:currentPage];
    }

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[searchBar resignFirstResponder];
    // set variables to default values
    //[self.recipesDisplayTable setContentOffset:CGPointZero animated:YES];//scroll up tableview
    currentPage = 1;
    
    [self.recipesList initWithNil];
    NSLog(@"start search...");
    currentDisplayType = Search;
    [self sendQuery:currentDisplayType SearchQuery:[self.searchBar text] page:currentPage];
//    [self.recipesDisplayTable reloadData];
//    self.labelTitle.text = [NSString stringWithFormat:@"Search results:%i",recipesCount];

}



#pragma mark - Table view data source

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    // The header for the section is the region name -- get this from the region at the section index.
//    
//    return @"";
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection: getting count %i",[self getCount]);
    return [self getCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Item"];
    }
    cell.textLabel.text =  [[self.recipesList.recipes objectAtIndex:indexPath.row] title];
    NSString *details = [[NSString alloc] initWithFormat:@"publisher: %@, rank: %@", [[self.recipesList.recipes objectAtIndex:indexPath.row] publisher], [[self.recipesList.recipes objectAtIndex:indexPath.row] social_rank]];
//    NSLog(@"cellForRowAtIndexPath: upd cell with data: %li title: %@\ndetail: %@\nimg: %@",indexPath.row, cell.textLabel.text, details, self.recipesList.imagesList[indexPath.row]);
    cell.detailTextLabel.text = details;
//    [cell.imageView setImageWithURL:[NSURL URLWithString:self.imagesList[indexPath.row]]];//simple and not optimal
    [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[self.recipesList.recipes objectAtIndex:indexPath.row] image_url]]
                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:cacheInterval];
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
//displaying star rating
//    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(400,120, 170, 20)];
//    starRatingView.maximumValue = 5;
//    starRatingView.minimumValue = 0;
//    starRatingView.value = [self.recipesList.social_rank[indexPath.row] floatValue]/20;
//    starRatingView.tintColor = [UIColor redColor];
//    [starRatingView addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
//    [cell.contentView addSubview:starRatingView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"item selected: %li, rId:%@, sender: %@",indexPath.row,[[self.recipesList.recipes objectAtIndex:indexPath.row] recipe_id],self);
    
    selectedItem = (int)indexPath.row;
    
    if ([[self.recipesList.recipes objectAtIndex:indexPath.row] recipe_id] == NULL) {
        NSLog(@"No data, can't display!");
        NSString *message = @"Error: seems like this item is empty";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        int duration = 5; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        return;
    }
    
    self.choosedId = [[self.recipesList.recipes objectAtIndex:indexPath.row] recipe_id];
    [self performSegueWithIdentifier:@"showRecipe" sender:self];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//}

#pragma mark - custom methods





@end
