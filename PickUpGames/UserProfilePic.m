//
//  UserProfilePic.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/14/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "UserProfilePic.h"

static NSString * const GameClassName = @"UserProfilePic";


@implementation UserProfilePic

@dynamic userProfilePic;
@dynamic user;

+ (NSString *)parseClassName {
    return GameClassName;
}

@end
