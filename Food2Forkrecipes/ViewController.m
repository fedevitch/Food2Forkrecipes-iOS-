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
int Trending = 1;
int TopRated = 2;
int Search = 3;

//@synthesize recipesDisplayTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.recipesDisplayTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 380, 650) style:UITableViewStylePlain];
    //self.recipesDisplayTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.recipesDisplayTable.delegate = self;
    self.recipesDisplayTable.dataSource = self;
    [self.recipesDisplayTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Item"];
    //self.view = self.recipesDisplayTable;
    NSLog(@"init table");
    [self sendQuery:Trending SearchQuery:@""];
    //[self.recipesDisplayTable reloadData];

    
}

#pragma mark - Custom methods

static NSString * const baseURL = @"http://food2fork.com/api/";


//@synthesize queryResponse;

int recipesCount = 0;

-(int)getCount
{
    return recipesCount;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Trending";
        //self.tabBarItem.image = [UIImage imageNamed:@"scr1"];
    }
    return self;
}


-(void)sendQuery:(int)queryType SearchQuery:(NSString*)Query
{
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=31a6f30afb8d54d0e8f54b624e200e47&sort=t",baseURL]];//default value
    if (queryType == Trending) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=31a6f30afb8d54d0e8f54b624e200e47&sort=t",baseURL]];
    }
    if (queryType == TopRated) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=31a6f30afb8d54d0e8f54b624e200e47&sort=r",baseURL]];
    }
    if (queryType == Search) {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=31a6f30afb8d54d0e8f54b624e200e47&q=%@",baseURL,Query]];
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
    for(NSDictionary *element in recipesList){
        NSLog(@"index %i", index+1);
        
        //NSLog(@"f2f_url: %@",element[@"f2f_url"]);
        //NSLog(@"image_url: %@",element[@"image_url"]);
        
        [self.titlesList addObject:element[@"title"]];
        [self.imagesList addObject:element[@"image_url"]];
        [self.publisher addObject:element[@"publisher"]];
        [self.social_rank addObject:element[@"social_rank"]];
        NSLog(@"Title: %@",self.titlesList[index]);
        NSLog(@"Image: %@",self.imagesList[index]);
        NSLog(@"publisher: %@",self.publisher[index]);
        NSLog(@"rank: %@",self.social_rank[index]);
        
        index++;
        
    }
    [self.recipesDisplayTable reloadData];
    
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        NSLog(@"switched to Top Rated");
         [self sendQuery:TopRated SearchQuery:@""];
    }
    else{
        //toggle the correct view to be visible
        NSLog(@"switched to Trending");
         [self sendQuery:Trending SearchQuery:@""];
     }
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Item"];
    }
    cell.textLabel.text = self.titlesList[indexPath.row];
    NSString *details = [[NSString alloc] initWithFormat:@"publisher: %@ rank: %@", self.publisher[indexPath.row], self.social_rank[indexPath.row]];
    NSLog(@"detail: %@", details);
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
