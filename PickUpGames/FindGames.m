//
//  HomeViewController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 6/25/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "FindGames.h"
#import "RegisterPageViewController.h"
#import "GameController.h"
#import "ResultsTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GameDetailViewController.h"
#import "HomePageTableViewCell.h"
#import <pop/POP.h>


@interface FindGames () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, CLLocationManagerDelegate> // We need these protocols to make our uisearchcontroller to work.

@property (weak, nonatomic) IBOutlet UITableView *tableView; // Our main TableView before it's been filtered
@property (nonatomic, strong) UISearchController *searchController; //  Our SearchController Object that includes a search bar under the navigation controller
@property (nonatomic,strong) ResultsTableViewController *resultsTableController; // The table that our search controller is going to update with the filtered results
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *city;

@end

@implementation FindGames

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    _resultsTableController = [[ResultsTableViewController alloc]init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController]; // Here we are linking our search controller with the tableview that we crreated to filter the results
    self.searchController.searchResultsUpdater = self; // This class is going to be dealing with the updating of the data <UISearchResultUpdating>
    [self.searchController.searchBar sizeToFit]; //deals with an autolayout bug
    self.tableView.tableHeaderView = self.searchController.searchBar; // This is going to set a Search Bar under the Navigation Bar.
    
    // MARK: Setting the delegates
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;// it dims the background when the the search is active
    self.searchController.searchBar.delegate = self; // This delegate is going to help us know when the text has been changed or added.
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    self.locationManager = [[CLLocationManager alloc] init]; // initializing locationManager
    self.locationManager.delegate = self; // we set the delegate of locationManager to self.
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
//    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
//    {
//    }
    
    [[GameConfirmationController sharedInstance] gamesGoingTo:[PFUser currentUser] withCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"SUCCESS FOR GAMES GOING TO");
        }
    }];

    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"notLoggedIn" sender:nil];
        //                    UIViewController *loginView = [LoginViewController new];
        //                    [self presentViewController:loginView animated:YES completion:nil];
    }
    [self.locationManager requestWhenInUseAuthorization];

    
    [[GameController sharedInstance] getGames:^(BOOL success) {
            [self.tableView reloadData];
    }];
    [self.locationManager startUpdatingLocation];
}


- (void)viewDidAppear:(BOOL)animated {
    
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}


- (IBAction)logoutButtonTapped:(id)sender {
    [PFUser logOutInBackground];
}

#pragma mark - Location stuff

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [manager stopUpdatingLocation];
    
    NSLog(@"current location: %@", location);
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error)
        {
            NSLog(@"error: %@",error);
        }
        else
        {
            CLPlacemark *placeMark = [placemarks lastObject];
            self.city = placeMark.addressDictionary[@"City"];
            NSLog(@"This is the city: %@", placeMark.addressDictionary[@"City"]);
            [[GameController sharedInstance] getGamesWithCity:self.city withCompletion:^(BOOL success) {
                if(success)
                {
                    [self.tableView reloadData];
                }
            }];
        }
    }];
    
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation *crnLoc = [locations lastObject];
//    latitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
//    longitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
//    altitude.text = [NSString stringWithFormat:@"%.0f m",crnLoc.altitude];
//    speed.text = [NSString stringWithFormat:@"%.1f m/s", crnLoc.speed];
//}



#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder]; // It makes the keyboard dismiss after they hit the SEARCH button
}

#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GameController sharedInstance].gamesFromCity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Game *game = [GameController sharedInstance].gamesFromCity[indexPath.row];
    
    HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = game.sportName;
    
    return cell;
}

//+ (BFTask *)logOutInBackground {
//    return [PFUser currentUser];
//}
#pragma mark -
#pragma mark - UITableViewDelegate

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [[GameController sharedInstance].games mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"sportName"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // Location field matching
        lhs = [NSExpression expressionForKeyPath:@"city"];
        finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // Where field matching
        lhs = [NSExpression expressionForKeyPath:@"where"];
        finalPredicate = [NSComparisonPredicate
                          predicateWithLeftExpression:lhs
                          rightExpression:rhs
                          modifier:NSDirectPredicateModifier
                          type:NSContainsPredicateOperatorType
                          options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        
//        // yearIntroduced field matching
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
//        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
//        if (targetNumber != nil) {   // searchString may not convert to a number
//            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//            
//            // price field matching
//            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//        }
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    ResultsTableViewController *tableController = (ResultsTableViewController *)self.searchController.searchResultsController;
    tableController.filteredGames = searchResults;
    [tableController.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == self.tableView) {
        [self performSegueWithIdentifier:@"gameSelectedSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
    } else {
        [self performSegueWithIdentifier:@"searchedGameSelectedSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    GameDetailViewController *detailView = [segue destinationViewController];
    
    // if the didSelect is from the search result, get game from self.resultsTableController.filteredGames
    // else get game from [GameController sharedInstance].gamesFromCity[indexPath.row];
    
    if ([segue.identifier isEqualToString:@"searchedGameSelectedSegue"]) {
        NSIndexPath *indexPath = [self.resultsTableController.tableView indexPathForSelectedRow];

        Game *game = self.resultsTableController.filteredGames[indexPath.row];
        detailView.game = game;
    } else if ([segue.identifier isEqualToString:@"gameSelectedSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        Game *game = [GameController sharedInstance].gamesFromCity[indexPath.row];
        detailView.game = game;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
