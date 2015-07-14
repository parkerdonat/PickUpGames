//
//  MainSearchTableViewController.h
//  PickUpGames
//
//  Created by Kaleo Kim on 7/2/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ResultsTableViewController : BaseTableViewController // Subclass of the BaseTableViewController so we can have the same properties

@property (nonatomic,strong) NSArray *filteredGames;

@end
