//
//  PhotoViewController.m
//  FirstApp
//
//  Created by Lubomyr Fedevych on 8/7/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+AFNetworking.h"



@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [imageView setImageWithURL:[NSURL URLWithString:self.imageFilename]];
    imageView.frame = CGRectMake(10,10,300,300);
    
    [self.view addSubview:imageView];
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
