//
//  GameController.h
//  PickUpGames
//
//  Created by Kaleo Kim on 6/19/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface GameController : NSObject

+ (GameController *)sharedInstance;


@property (nonatomic,strong) NSArray * games;
@property (nonatomic,strong) NSArray * gamesFromCity;
@property (nonatomic,strong) NSArray * gamesFromUser;
@property (nonatomic,strong) NSArray * gamesGoing;


- (void)createGameWithName:(NSString *)name city:(NSString *)city where:(NSString *)where dateAndTime:(NSDate *)dateAndTime creator:(PFUser *)creator;
- (void)getGames:(void (^)(BOOL success))completion;
- (void)getGamesWithCity:(NSString *)city withCompletion:(void (^)(BOOL success))completion;
- (void)getGamesfromUser:(void (^)(void))completion;
- (void)addUserToGame:(Game *)game user:(PFUser *)user;


@end
