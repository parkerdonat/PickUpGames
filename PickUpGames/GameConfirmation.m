//
//  GameConfirmation.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/9/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "GameConfirmation.h"

static NSString * const GameClassName = @"GameConfirmation";

@implementation GameConfirmation

@dynamic game;
@dynamic user;

+ (NSString *)parseClassName {
    return GameClassName;
}

@end
