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

#import "HCSStarRatingView/HCSStarRatingView.h"

#import "MWFeedParser/Classes/NSString+HTML.h"


@class RecipesList;

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
NSString* choosedId;
bool updatingList = NO;


//@synthesize recipesDisplayTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.recipesList = [[RecipesList alloc] init];
    self.recipesDisplayTable.delegate = self;
    self.recipesDisplayTable.dataSource = self;
    //[self.recipesDisplayTable registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"Item"];
    NSLog(@"viewDidLoad: Is returning back? : %@",isReturningBack?@"Yes":@"No");
    if (isReturningBack) {
        [self.recipesDisplayTable reloadData];
    }
    else{

        [self listsInitialize];
        [self sendQuery:Trending SearchQuery:@"" page:currentPage];
    }

    

}


-(void)returnBack:(DisplayRecipeController *)displayRecipe isReturn:(BOOL)isReturning recipesList:(RecipesList *)savedList
{
//    self.recipesDisplayTable.delegate = self;
//    self.recipesDisplayTable.dataSource = self;
    isReturningBack = isReturning;
    [self listsInitialize];
    self.recipesList = savedList;
    //[self.recipesDisplayTable reloadData];
    NSLog(@"Delegate returnBack: isReturningBack set to: %@",isReturningBack?@"Yes":@"No");
    NSLog(@"Delegate returnBack: what is returned: titles %@",self.recipesList.titlesList);
    [self.recipesDisplayTable reloadData];
    [self printLog];
    //    NSLog(@"Delegate returnBack: we getted data back");
}

-(void)printLog{
    NSLog(@"Log: current var state: %@",self.recipesList.recipe_id);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSLog(@"viewWillAppear: reloading data");
    [self.recipesDisplayTable reloadData]; // to reload selected cell
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue... id: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"showRecipe"]) {
        //UINavigationController *navigationController = (UINavigationController*)segue.destinationViewController;//uncomment if using nav controller
        //DisplayRecipeController *recipeDetails = (DisplayRecipeController*)navigationController.topViewController;
        DisplayRecipeController *recipeDetails = (DisplayRecipeController*)segue.destinationViewController;
//        recipeDetails.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *detailsPresentation = recipeDetails.popoverPresentationController;
        detailsPresentation.delegate = (id<UIPopoverPresentationControllerDelegate>)self;
        recipeDetails.delegate = self;
        recipeDetails.recipeId = self.recipesList.recipe_id[selectedItem];
        recipeDetails.listSaver = self.recipesList;

//        [self.popoverPresentationController dismissalTransitionDidEnd:YES];
//        self.popoverPresentation = ((UIStoryboardPopoverSegue*)segue).popoverController;
        NSLog(@"Sending recipeId: %@",recipeDetails.recipeId);
        

    }
//    if ([segue.identifier isEqualToString:@"returnToList"]) {
//        NSLog(@"Main view: returning to list..");
//    }
}

#pragma mark - Custom methods

int recipesCount = 0;
int selectedItem = 0;

-(int)getCount
{
    return recipesCount;
}

-(RecipesList*)getRecipesList{
    return self.recipesList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Recipes";
        //self.tabBarItem.image = [UIImage imageNamed:@"scr1"];
    }
    return self;
}


-(void)sendQuery: (int)queryType SearchQuery:(NSString*)Query page:(int)page
{

    //[self.recipesDisplayTable setContentOffset:CGPointZero animated:YES];//scroll up tableview
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=t",baseURL,apiKey]];//default value
    if (queryType == Trending) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=t&page=%i",baseURL,apiKey,currentPage]];
        currentDisplayType = Trending;
        self.navigationItem.title = @"Trending";
//        self.labelTitle.text = [NSString stringWithFormat:@"Current page:%i",currentPage];

    }
    if (queryType == TopRated) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=r&page=%i",baseURL,apiKey,currentPage]];
        currentDisplayType = TopRated;
        self.navigationItem.title = @"Top Rated";
//        self.labelTitle.text = [NSString stringWithFormat:@"Current page:%i",currentPage];

    }
    if (queryType == Search) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&q=%@&page=%i",baseURL,apiKey,Query,currentPage]];
        currentDisplayType = Search;
        self.navigationItem.title =[NSString stringWithFormat:@"Search results for: %@",Query ];
        [self.displayTypeChanger setSelectedSegmentIndex:UISegmentedControlNoSegment];
        //currentPage = 1;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.queryResponse = [NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:NSJSONReadingMutableContainers
                              error:nil];
        [self requestSuccessfull];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
        //using alertview
        NSString *message = [NSString stringWithFormat:@"error:  %@",[error localizedDescription] ];
        
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
    }];
    
    [operation start];
    
}

-(void) requestSuccessfull
{
    NSLog(@"Query success. Count: %@",self.queryResponse[@"count"]);
    recipesCount += (int)[self.queryResponse[@"count"] integerValue];
    
    NSArray *receivedList = self.queryResponse[@"recipes"];
    
//    int index = 0;//for log output

    
    for(NSDictionary *element in receivedList){
        //NSString *title = [[NSString alloc] initWithString:element[@"title"]];
        //[title stringByEncodingHTMLEntities];
        //add data
        [self.recipesList.titlesList addObject:[element[@"title"] stringByDecodingHTMLEntities]];
        [self.recipesList.imagesList addObject:element[@"image_url"]];
        [self.recipesList.publisher addObject:element[@"publisher"]];
        [self.recipesList.social_rank addObject:element[@"social_rank"]];
        [self.recipesList.recipe_id addObject:element[@"recipe_id"]];
        [self.recipesList.publisher_url addObject:element[@"publisher_url"]];
        [self.recipesList.source_url addObject:element[@"source_url"]];
        
        //log messages
//        NSLog(@"index %i", index+1);
//        NSLog(@"Title: %@",self.titlesList[index]);
        
//        NSLog(@"Image: %@",self.imagesList[index]);
//        NSLog(@"publisher: %@",self.publisher[index]);
//        NSLog(@"rank: %@",self.social_rank[index]);
//        NSLog(@"id: %@",self.recipe_id[index]);
//        NSLog(@"publisher URL: %@",self.publisher_url[index]);
//        NSLog(@"source URL: %@",self.source_url[index]);
//        index++;
        
    }

//    NSLog(@"Title: %@",[self.recipesList titlesList]);
    [self.recipesDisplayTable reloadData];
//    updatingList = NO;
    
}

-(void)listsInitialize//initialize arrays with nil values
{
    NSLog(@"listsInitialize: doing alloc-initWithObjects: nil for lists");
    self.recipesList.titlesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipesList.imagesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipesList.publisher = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipesList.social_rank = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipesList.recipe_id = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipesList.publisher_url = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipesList.source_url = [[NSMutableArray alloc] initWithObjects: nil];
}

#pragma mark - controls

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    [self.recipesDisplayTable setContentOffset:CGPointZero animated:YES];//scroll up tableview
        // set variables to default values
    [self listsInitialize];
    self.searchBar.text = @"";
    currentPage = 1;
    recipesCount = 0;
    [self.recipesDisplayTable reloadData];
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        NSLog(@"switched to Top Rated");
        
        [self sendQuery:TopRated SearchQuery:@"" page:currentPage];
    }
    else{
        //toggle the correct view to be visible
        
        NSLog(@"switched to Trending");
        [self sendQuery:Trending SearchQuery:@"" page:currentPage];
     }
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // set variables to default values
    [self.recipesDisplayTable setContentOffset:CGPointZero animated:YES];//scroll up tableview
    currentPage = 1;
    recipesCount = 0;
    [self listsInitialize];
    [self.recipesDisplayTable reloadData];
    NSLog(@"start search...");
    currentDisplayType = Search;
    [self sendQuery:currentDisplayType SearchQuery:[self.searchBar text] page:currentPage];
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

//    cell.textLabel.text = recipesList.titlesList[indexPath.row];
     cell.textLabel.text =  self.recipesList.titlesList[indexPath.row];
    NSString *details = [[NSString alloc] initWithFormat:@"publisher: %@, rank: %@", self.recipesList.publisher[indexPath.row], self.recipesList.social_rank[indexPath.row]];
    NSLog(@"cellForRowAtIndexPath: upd cell with data: %li title: %@\ndetail: %@\nimg: %@",indexPath.row, cell.textLabel.text, details, self.recipesList.imagesList[indexPath.row]);
    cell.detailTextLabel.text = details;
//    [cell.imageView setImageWithURL:[NSURL URLWithString:self.imagesList[indexPath.row]]];//simple and not optimal
    [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.recipesList.imagesList[indexPath.row]]
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
    NSLog(@"item selected: %li, rId:%@, sender: %@",indexPath.row,self.recipesList.recipe_id[indexPath.row],self);
    
    selectedItem = (int)indexPath.row;
    
    if (self.recipesList.recipe_id[indexPath.row] == NULL) {
        NSLog(@"No data, can't display!");
        return;
    }
    
    self.choosedId = self.recipesList.recipe_id[indexPath.row];
    
    isReturningBack = YES;
    
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
