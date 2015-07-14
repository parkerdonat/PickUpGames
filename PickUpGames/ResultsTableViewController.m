//
//  MainSearchTableViewController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/2/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "ResultsTableViewController.h"
#import "Game.h"
#import "GameController.h"
#import "GameDetailViewController.h"

@interface ResultsTableViewController () <UITableViewDelegate>

//@property (strong, nonatomic) ResultsTableViewController *resultTableView;

@end

@implementation ResultsTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredGames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Game *game = self.filteredGames[indexPath.row];
    cell.textLabel.text = game.sportName;
    
    return cell;
}

@end
