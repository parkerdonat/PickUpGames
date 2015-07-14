//
//  GameController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 6/19/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "GameController.h"

@implementation GameController

+ (GameController *)sharedInstance {
    static GameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [GameController new];
    });
    return sharedInstance;
}

- (void)createGameWithName:(NSString *)name city:(NSString *)city where:(NSString *)where dateAndTime:(NSDate *)dateAndTime creator:(PFUser *)creator {
    
    Game *game = [Game new];
    
    PFACL *userACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    game.sportName = name;
    game.city = city;
    game.where = where;
    game.dateAndTime = dateAndTime;
    game.gameCreator = creator;
    game.usersGoing = @[];
    game.ACL = userACL;
    
    [game saveInBackground];
}

- (void)getGames:(void (^)(BOOL success))completion
{
    PFQuery *query = [Game query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
       
        self.games = [[NSArray alloc] initWithArray:objects]; //Get all the games and put them into the public array of games.
        completion(YES);
    }];
    
}

- (void)getGamesWithCity:(NSString *)city withCompletion:(void (^)(BOOL success))completion
{
    
    PFQuery *query = [[Game query] whereKey:@"city" equalTo:city];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.gamesFromCity = [[NSArray alloc] initWithArray:objects];
        completion(YES);
    }];
}

- (void)getGamesfromUser:(void (^)(void))completion
{
    
    PFQuery *query = [[Game query] whereKey:@"gameCreator" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.gamesFromUser = objects;
        completion();
    }];
}





//- (void)createGameWithName:(NSString *)name city:(NSString *)city where:(NSString *)where dateAndTime:(NSDate *)dateAndTime creator:(PFUser *)creator publicOrNot:(BOOL)publicOrNot {
//    
//    Game *game = [Game new];
//    
//    game.sportName = name;
//    game.city = city;
//    game.where = where;
//    game.dateAndTime = dateAndTime;
//    game.gameCreator = creator;
//    game.publicOrPrivate = publicOrNot;
//    
//    [game saveInBackground];
//}

@end
