//
//  UserProfilePicController.h
//  PickUpGames
//
//  Created by Kaleo Kim on 7/14/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfilePic.h"

@interface UserProfilePicController : NSObject

@property (strong, nonatomic) UIImageView *profilePicImageView;
@property (strong, nonatomic) UserProfilePic *profilePicObj;
+ (UserProfilePicController *)sharedInstance;
- (void)savePhotoForUser:(PFUser *)user profilePic:(UIImage *)profilePic;
- (void)getProfilePics:(PFUser *)user withCompletion:(void (^)(UserProfilePic *userProfilePic))completion;
@end
