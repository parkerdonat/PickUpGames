//
//  BaseTableViewController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/2/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GameDetailViewController.h"
#import "HomePageTableViewCell.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

@end
