//
//  UserProfilePicController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/14/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "UserProfilePicController.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    [self getProfilePics:user withCompletion:^(UserProfilePic *userProfilePic) {
        // If user has current pic, userProfilePic != nil
        if (userProfilePic != nil) {
            [self deleteUserProfilePic:userProfilePic];
        }
        
        UserProfilePic *newProfilePic = [UserProfilePic new];
        
        newProfilePic.userProfilePic = [PFFile fileWithData:UIImageJPEGRepresentation(profilePic, 0.95)];
        
        newProfilePic.user = user;
        
        [newProfilePic saveInBackground];
    }];
    
   
    
}

//-(void)updatePhotoForUser:(PFUser *)user

- (void)getProfilePics:(PFUser *)user withCompletion:(void (^)(UserProfilePic *userProfilePic))completion {
    self.profilePicImageView = [UIImageView new];
    PFQuery *query = [[UserProfilePic query] whereKey:@"user" equalTo:user];
//    [query includeKey:@"userProfilePic"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.profilePicObj = [objects firstObject];
            [self.profilePicImageView sd_setImageWithURL:[NSURL URLWithString:self.profilePicObj.userProfilePic.url]];
            completion(self.profilePicObj);
        } else {
            completion(nil);
        }
    }];
}

- (void)deleteUserProfilePic:(UserProfilePic *)profilePic {
    [profilePic deleteInBackground];
}

@end
