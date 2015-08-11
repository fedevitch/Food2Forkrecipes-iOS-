//
//  ViewController.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/5/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import "ViewController.h"
//#import "RecipesTableViewController.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoViewController.h"



@interface ViewController ()


@end

@implementation ViewController

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

//@synthesize recipesDisplayTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.recipesDisplayTable.delegate = self;
    self.recipesDisplayTable.dataSource = self;
    
    //[self.recipesDisplayTable registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"Item"];


    //NSLog(@"init table");
    [self sendQuery:Trending SearchQuery:@"" page:currentPage];

}

#pragma mark - Custom methods

int recipesCount = 0;

-(int)getCount
{
    return recipesCount;
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
    if (currentPage == 1) {
        [self.previousButton setEnabled:NO];
    }
    else{
        [self.previousButton setEnabled:YES];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=t",baseURL,apiKey]];//default value
    if (queryType == Trending) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=t&page=%i",baseURL,apiKey,currentPage]];
        currentDisplayType = Trending;
        self.labelTitle.text = [NSString stringWithFormat:@"Current page:%i",currentPage];
        [self.nextButton setEnabled:YES];
        
    }
    if (queryType == TopRated) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&sort=r&page=%i",baseURL,apiKey,currentPage]];
        currentDisplayType = TopRated;
        self.labelTitle.text = [NSString stringWithFormat:@"Current page:%i",currentPage];
        [self.nextButton setEnabled:YES];
    }
    if (queryType == Search) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=%@&q=%@&page=%i",baseURL,apiKey,Query,currentPage]];
        currentDisplayType = Search;
        //[self.previousButton setEnabled:NO];
        [self.nextButton setEnabled:YES];
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
    }];
    
    [operation start];
    
}

-(void) requestSuccessfull
{
    NSLog(@"Query success. Count: %@",self.queryResponse[@"count"]);
    recipesCount = (int)[self.queryResponse[@"count"] integerValue];
    
    NSArray *recipesList = self.queryResponse[@"recipes"];
    int index = 0;
    
    self.titlesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.imagesList = [[NSMutableArray alloc] initWithObjects: nil];
    self.publisher = [[NSMutableArray alloc] initWithObjects: nil];
    self.social_rank = [[NSMutableArray alloc] initWithObjects: nil];
    self.recipe_id = [[NSMutableArray alloc] initWithObjects: nil];
    self.publisher_url = [[NSMutableArray alloc] initWithObjects: nil];
    self.source_url = [[NSMutableArray alloc] initWithObjects: nil];
    for(NSDictionary *element in recipesList){
        
//        NSAttributedString *title = [[NSAttributedString alloc] initWithData:[element[@"title"] dataUsingEncoding:NSUTF8StringEncoding] //parse html codes options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];         //it works too slow
        
        //add data
        [self.titlesList addObject:[self parseHtmlCodes:element[@"title"]]];
        [self.imagesList addObject:element[@"image_url"]];
        [self.publisher addObject:element[@"publisher"]];
        [self.social_rank addObject:element[@"social_rank"]];
        [self.recipe_id addObject:element[@"recipe_id"]];
        [self.publisher_url addObject:element[@"publisher_url"]];
        [self.source_url addObject:element[@"source_url"]];
        
        //log messages
        NSLog(@"index %i", index+1);
        NSLog(@"Title: %@",self.titlesList[index]);
        NSLog(@"Image: %@",self.imagesList[index]);
        NSLog(@"publisher: %@",self.publisher[index]);
        NSLog(@"rank: %@",self.social_rank[index]);
        NSLog(@"id: %@",self.recipe_id[index]);
        NSLog(@"publisher URL: %@",self.publisher_url[index]);
        NSLog(@"source URL: %@",self.source_url[index]);
        index++;
        
    }
    [self.recipesDisplayTable reloadData];
    
}

#pragma mark - controls

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
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
- (IBAction)previousButtonTouchUpInside:(id)sender {
    currentPage -= 1;
    [self sendQuery:currentDisplayType SearchQuery:@"" page:currentPage];
}
- (IBAction)nextButtonTouchUpInside:(id)sender {
    currentPage += 1;
    [self sendQuery:currentDisplayType SearchQuery:@"" page:currentPage];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
    currentPage = 1;
    NSLog(@"start search...");
    currentDisplayType = Search;
    [self sendQuery:currentDisplayType SearchQuery:[self.searchBar text] page:currentPage];
    self.labelTitle.text = [NSString stringWithFormat:@"Search results:%i",recipesCount];

}

-(NSString*)parseHtmlCodes:(NSString*)input {
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
    return [self getCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Item"];
    }

    cell.textLabel.text = self.titlesList[indexPath.row];
    NSString *details = [[NSString alloc] initWithFormat:@"publisher: %@, rank: %@", self.publisher[indexPath.row], self.social_rank[indexPath.row]];
    //NSLog(@"detail: %@", details);
    cell.detailTextLabel.text = details;
    [cell.imageView setImageWithURL:[NSURL URLWithString:self.imagesList[indexPath.row]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    
    photoVC.imageFilename = self.imagesList[indexPath.row];
    
    [self.navigationController pushViewController:photoVC animated:YES];
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





@end