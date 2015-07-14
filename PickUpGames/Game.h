//
//  Game.h
//  PickUpGames
//
//  Created by Kaleo Kim on 6/19/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Game : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *sportName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *where;
@property (strong, nonatomic) NSDate *dateAndTime;
@property (strong, nonatomic) PFUser *gameCreator;
@property (strong, nonatomic) PFUser *usersGoing;
@property (assign, nonatomic) BOOL publicOrPrivate;

+ (NSString *)parseClassName;

@end
