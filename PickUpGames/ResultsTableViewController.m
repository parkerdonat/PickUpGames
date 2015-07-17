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
#import "CustomTableViewCell.h"

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
    [tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCellXib"];
    
    CustomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CustomCellXib"];
    
    Game *game = self.filteredGames[indexPath.row];
    
    cell.sportName.text = game.sportName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, hh:mm a"];
    cell.dateAndTime.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:game.dateAndTime]];
    
    cell.city.text = game.city;
    
    return cell;
}
//[tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCellXib"];
//
//Game *game = [GameController sharedInstance].gamesFromCity[indexPath.row];
//
//CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellXib"];
//if (!cell) {
//    cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomCellXib"];
//}
//
//if (cell == nil)
//{
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
//    cell = [nib objectAtIndex:0];
//}
//
//cell.sportName.text = game.sportName;
//NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//[formatter setDateFormat:@"MMMM dd, hh:mm a"];
//cell.dateAndTime.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:game.dateAndTime]];
//
//cell.city.text = game.city;
//
//return cell;

@end
