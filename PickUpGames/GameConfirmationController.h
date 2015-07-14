//
//  GameConfirmationController.h
//  PickUpGames
//
//  Created by Kaleo Kim on 7/9/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"


@interface GameConfirmationController : NSObject

@property (strong, nonatomic) NSArray *gamesUserIsGoingTo;

+ (GameConfirmationController *)sharedInstance;
- (void)createConfirmationToGame:(Game *)game user:(PFUser *)user;
- (void)gamesGoingTo:(PFUser *)user withCompletion:(void (^)(BOOL success))completion;

@end
