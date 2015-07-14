//
//  Group.h
//  PickUpGames
//
//  Created by Kaleo Kim on 6/19/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Group : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) NSString *groupLocation;


+ (NSString *)parseClassName;

@end
