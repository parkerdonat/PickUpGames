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

@implementation GameDetailCollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  [collectionView registerClass:[GameDetailCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    GameDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    [cell.myImageView setBackgroundColor:[UIColor blackColor]];
    [cell.myImageView.layer setCornerRadius:45];

    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}

@end
