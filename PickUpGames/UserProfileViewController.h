//
//  UserProfileViewController.h
//  PickUpGames
//
//  Created by Kaleo Kim on 6/29/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDetailViewController.h"

typedef NS_ENUM(NSUInteger, profileSections) {
    profileSectionsAddGame,
    profileSectionsGamesPosted,
    profileSectionsGamesGoing,
    profileSectionsLogOut
};

@interface UserProfileViewController : UIViewController

@property (assign, nonatomic) profileSections section;

@end
