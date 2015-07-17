//
//  GameConfirmationController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/9/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "GameConfirmationController.h"
#import "GameConfirmation.h"

@implementation GameConfirmationController

+ (GameConfirmationController *)sharedInstance {
    static GameConfirmationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [GameConfirmationController new];
    });
    return sharedInstance;
}

- (void)createConfirmationToGame:(Game *)game user:(PFUser *)user withCompletion:(void (^)(BOOL success))completion {
    
    
    PFObject *confirmation = [PFObject objectWithClassName:@"GameConfirmation"];
    
    [confirmation setObject:user  forKey:@"user"];
    //[confirmation setObject:otherUser forKey:@"to"];
    [confirmation setObject:game forKey:@"game"];
    [confirmation saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (success) {
            [self.usersGoingToGame addObject:confirmation];
            completion(YES);
        } else {
            completion(NO);
        }
    } ];
    
}

- (void)gamesGoingTo:(PFUser *)user withCompletion:(void (^)(BOOL success))completion {
    
    PFQuery *query = [[GameConfirmation query] whereKey:@"user" equalTo:user];
    [query includeKey:@"game"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.gamesUserIsGoingTo = objects;
            completion(YES);
        } else {
            completion(NO);
        }

    }];
    
}

- (void)usersGoingToGame:(Game *)game withCompletion:(void (^)(BOOL success))completion {
    
    PFQuery *query = [[GameConfirmation query] whereKey:@"game" equalTo:game];
    [query includeKey:@"user"];
    self.usersGoingToGame = [NSMutableArray new];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            for (GameConfirmation *gameConfirmed in objects) {
                [self.usersGoingToGame addObject:[gameConfirmed objectForKey:@"user"]];
            }
            completion(YES);
        } else {
            completion(NO);
        }
    }];
}

- (void)deleteGameConfirmation:(GameConfirmation *)game {
    [self.usersGoingToGame removeObject:game];
    [game delete];
}

@end
