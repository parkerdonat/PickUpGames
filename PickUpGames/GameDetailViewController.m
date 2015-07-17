//
//  GameDetailViewController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 7/7/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "GameDetailViewController.h"
#import "GameConfirmationController.h"



@interface GameDetailViewController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet UILabel *whereLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *imInButton;


@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.imInButton.backgroundColor = [UIColor blueColor];
    
    [self.navigationController.navigationBar setHidden:NO];

    // Do any additional setup after loading the view.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    self.gameTitle.text = self.game.sportName;//.sportName;
    self.whereLabel.text = self.game.where;
    [formatter setDateFormat:@"MMMM dd, hh:mm a"];
    self.dateAndTimeLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.game.dateAndTime]];
    
    if (self.game) {
        [[GameConfirmationController sharedInstance] usersGoingToGame:self.game withCompletion:^(BOOL success) {
            if (success) {
                [self.collectionView reloadData];
            }
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinGameButtonTapped:(id)sender {
    //[[GameController sharedInstance] addUserToGame:self.game user:[PFUser currentUser]];
    
    [[GameConfirmationController sharedInstance] createConfirmationToGame:self.game user:[PFUser currentUser] withCompletion:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
//           NSIndexPath *indexPath = [self.collectionView indexPathForCell:[[self.collectionView visibleCells] lastObject]];
//            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }
    }];

    
}


#pragma mark-
#pragma mark- Collection View Delegate Methods

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = collectionView.frame.size.width / 3;
    return CGSizeMake( size, size);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 15, 0);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
