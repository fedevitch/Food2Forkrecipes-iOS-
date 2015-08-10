//
//  TestQueryViewController.m
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/5/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import "TestQueryViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
@interface TestQueryViewController ()

@end

@implementation TestQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://food2fork.com/api/search?key=31a6f30afb8d54d0e8f54b624e200e47&sort=t"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSString *result = [[NSString alloc] init];
    
    //deprecated
    //    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    //                                         success:^((NSURLRequest *request, NSHTTPURLResponse *response, id JSON)){
    //
    //                                         }
    //                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
    //                                                     NSError *error, id JSON) {
    //                                             NSLog(@"NSError: %@",error.localizedDescription);
    //                                         }];
    //    [operation start];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success: %@ \n \n", operation.responseString);
        self.result = [NSString stringWithFormat: operation.responseString];
        NSLog(@"Variable: %@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  operation.responseString);
    }];
    
    [operation start];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
