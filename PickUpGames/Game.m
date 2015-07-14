//
//  Game.m
//  PickUpGames
//
//  Created by Kaleo Kim on 6/19/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "Game.h"

static NSString * const GameClassName = @"Game";

@implementation Game

@dynamic sportName;
@dynamic city;
@dynamic where;
@dynamic dateAndTime;
@dynamic gameCreator;
@dynamic usersGoing;
@dynamic publicOrPrivate;

+ (NSString *)parseClassName {
    return GameClassName;
}

@end
