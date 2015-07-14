//
//  UserProfilePicController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/14/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "UserProfilePicController.h"

@implementation UserProfilePicController

+ (UserProfilePicController *)sharedInstance {
    static UserProfilePicController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [UserProfilePicController new];
    });
    return sharedInstance;
}

- (void)savePhotoForUser:(PFUser *)user profilePic:(UIImage *)profilePic {
    
    UserProfilePic *newProfilePic = [UserProfilePic new];
    
    newProfilePic.userProfilePic = [PFFile fileWithData:UIImageJPEGRepresentation(profilePic, 0.95)];
    
    newProfilePic.user = user;
    
    [newProfilePic saveInBackground];
    
}

@end
