//
//  GameDetailViewController.h
//  PickUpGames
//
//  Created by Kaleo Kim on 7/7/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "GameController.h"
#import "GameConfirmationController.h"

@interface GameDetailViewController : UIViewController

@property (strong, nonatomic) Game *game;

@end
