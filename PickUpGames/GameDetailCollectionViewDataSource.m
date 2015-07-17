//
//  GameDetailCollectionViewDataSource.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/9/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "GameDetailCollectionViewDataSource.h"
#import "GameController.h"
#import "GameDetailCollectionViewCell.h"
#import "GameConfirmationController.h"
#import "UserProfilePic.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GameDetailCollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([GameConfirmationController sharedInstance].usersGoingToGame && [GameConfirmationController sharedInstance].usersGoingToGame.count > 0) {
        return [GameConfirmationController sharedInstance].usersGoingToGame.count;
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  [collectionView registerClass:[GameDetailCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    GameDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    [cell.myImageView setBackgroundColor:[UIColor blackColor]];
    [cell.myImageView.layer setCornerRadius:45];
    
    PFUser *user = [GameConfirmationController sharedInstance].usersGoingToGame[indexPath.row];
    UserProfilePic *profilePic = [user objectForKey:@"profilePicPointer"];
    
//    if (profilePic != nil) {
        [profilePic fetchIfNeeded];
//    }

    if (!profilePic.userProfilePic.url) {
    cell.myImageView.image = [UserProfilePicController sharedInstance].profilePicImageView.image;
    }else{
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:profilePic.userProfilePic.url]];
    }
    
    if (!user[@"userRealName"]) {
        cell.userNameLabel.text = [[PFUser currentUser]objectForKey: @"userRealName"];
    } else {
        cell.userNameLabel.text = user[@"userRealName"];
    }
//    } else {
//        if (profilePic.userProfilePic.url) {
//            <#statements#>
//        }
//    }
 
    cell.backgroundColor =[UIColor clearColor];
   
    
    return cell;
}

@end
