//
//  ViewController.h
//  Food2Forkrecipes
//
//  Created by Lubomyr Fedevych on 8/5/15.
//  Copyright (c) 2015 Lubomyr Fedevych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *recipesDisplayTable;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *displayTypeChanger;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;


//data containers
@property (strong, nonatomic) NSDictionary *queryResponse;
@property (strong, nonatomic) NSMutableArray *titlesList;
@property (strong, nonatomic) NSMutableArray *imagesList;
@property (strong, nonatomic) NSMutableArray *publisher;
@property (strong, nonatomic) NSMutableArray *social_rank;
@property (strong, nonatomic) NSMutableArray *recipe_id;
@property (strong, nonatomic) NSMutableArray *publisher_url;
@property (strong, nonatomic) NSMutableArray *source_url;
@property (strong, nonatomic) NSMutableArray *f2f_url;

@end

