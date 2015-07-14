//
//  GameConfirmation.h
//  PickUpGames
//
//  Created by Kaleo Kim on 7/9/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Game.h"

@interface GameConfirmation : PFObject <PFSubclassing>

@property (strong,nonatomic) Game *game;
@property (strong,nonatomic) PFUser *user;

+ (NSString *)parseClassName;

@end
