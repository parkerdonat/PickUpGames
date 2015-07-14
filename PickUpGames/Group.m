//
//  Group.m
//  PickUpGames
//
//  Created by Kaleo Kim on 6/19/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "Group.h"

static NSString * const DishClassName = @"Group";

@implementation Group 

@dynamic groupName;
@dynamic groupLocation;


+ (NSString *)parseClassName {
    return DishClassName;
}

@end
