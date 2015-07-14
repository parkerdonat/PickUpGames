//
//  UserProfilePic.h
//  PickUpGames
//
//  Created by Kaleo Kim on 7/14/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserProfilePic : PFObject <PFSubclassing>

@property (strong, nonatomic) PFFile *userProfilePic;
@property (strong, nonatomic) PFUser *user;

+ (NSString *)parseClassName;

@end
