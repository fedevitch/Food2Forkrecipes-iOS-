//
//  RecipesTableViewController.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/7/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import "RecipesTableViewController.h"
//#import "RecipesQuerySender.h"
//#import "AFHTTPRequestOperation.h"
//#import "UIImageView+AFNetworking.h"
//#import "PhotoViewController.h"

@interface RecipesTableViewController ()

@end



@implementation RecipesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Trending";
        //self.tabBarItem.image = [UIImage imageNamed:@"scr1"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.recipesQuery = [[RecipesQuerySender alloc] init];
//    [self.recipesQuery sendQuery:1 SearchQuery:@""];
//    
//    NSLog(@"TableView update. Query res:%i",self.recipesQuery.getCount);
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Item"];
//    [self sendQuery:1 SearchQuery:@""];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Custom methods
//
//static NSString * const baseURL = @"http://food2fork.com/api/";
////1 - trending
////2 - top rated
////3 - search
//
////@synthesize queryResponse;
//
//int recipesCount = 0;
//
//-(int)getCount
//{
//    return recipesCount;
//}
//
//-(void)sendQuery:(int)queryType SearchQuery:(NSString*)Query
//{
//    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@search?key=31a6f30afb8d54d0e8f54b624e200e47&sort=t",baseURL]];
//    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.queryResponse = [NSJSONSerialization
//                              JSONObjectWithData:responseObject
//                              options:NSJSONReadingMutableContainers
//                              error:nil];
//        [self requestSuccessfull];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",  [error localizedDescription]);
//    }];
//    
//    [operation start];
//    
//}
//
//-(void) requestSuccessfull
//{
//    NSLog(@"Query success. Count: %@",self.queryResponse[@"count"]);
//    recipesCount = (int)[self.queryResponse[@"count"] integerValue];
//    
//    NSArray *recipesList = self.queryResponse[@"recipes"];
//    int index = 0;
//    
//    self.titlesList = [[NSMutableArray alloc] initWithObjects: nil];
//    self.imagesList = [[NSMutableArray alloc] initWithObjects: nil];
//    self.publisher = [[NSMutableArray alloc] initWithObjects: nil];
//    self.social_rank = [[NSMutableArray alloc] initWithObjects: nil];
//    for(NSDictionary *element in recipesList){
//        NSLog(@"index %i", index+1);
//        
//        //NSLog(@"f2f_url: %@",element[@"f2f_url"]);
//        //NSLog(@"image_url: %@",element[@"image_url"]);
//        
//        [self.titlesList addObject:element[@"title"]];
//        [self.imagesList addObject:element[@"image_url"]];
//        [self.publisher addObject:element[@"publisher"]];
//        [self.social_rank addObject:element[@"social_rank"]];
//        NSLog(@"Title: %@",self.titlesList[index]);
//        NSLog(@"Image: %@",self.imagesList[index]);
//        NSLog(@"publisher: %@",self.publisher[index]);
//        NSLog(@"rank: %@",self.social_rank[index]);
//        
//        index++;
//        
//    }
//    [self.tableView reloadData];
//    
//}
//
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return [self getCount];
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    if(cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Item"];
//    }
//    cell.textLabel.text = self.titlesList[indexPath.row];
//    NSString *details = [[NSString alloc] initWithFormat:@"publisher: %@ rank: %@", self.publisher[indexPath.row], self.social_rank[indexPath.row]];
//    NSLog(@"detail: %@", details);
//    cell.detailTextLabel.text = details;
//    [cell.imageView setImageWithURL:[NSURL URLWithString:self.imagesList[indexPath.row]]];
//
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
//    
//    photoVC.imageFilename = self.imagesList[indexPath.row];
//    
//    [self.navigationController pushViewController:photoVC animated:YES];
//}
//
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return NO;
//}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
