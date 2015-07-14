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

- (void)createConfirmationToGame:(Game *)game user:(PFUser *)user {
    
    
    PFObject *confirmation = [PFObject objectWithClassName:@"GameConfirmation"];
    
    [confirmation setObject:user  forKey:@"from"];
    //[confirmation setObject:otherUser forKey:@"to"];
    [confirmation setObject:game forKey:@"to"];
    [confirmation saveInBackground];
    
}

- (void)gamesGoingTo:(PFUser *)user withCompletion:(void (^)(BOOL success))completion {
    
    PFQuery *query = [[GameConfirmation query] whereKey:@"from" equalTo:user];
    [query includeKey:@"to"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.gamesUserIsGoingTo = objects;
    }];
    
}

@end
