//
//  UserProfileViewController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 6/29/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "UserProfileViewController.h"
#import "RegisterPageViewController.h"
#import "GameController.h"
#import <Parse/Parse.h>
#import "GameConfirmationController.h"
#import "UserProfilePicController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GameConfirmation.h"
#import "CustomTableViewCell.h"

static NSString * const kAddGameCell = @"addGameButtonCell";
static NSString * const kGamesPostedCell = @"gamesPostedCell";
static NSString * const kGamesGoingCell = @"gamesGoingCell";
static NSString * const kLogOutButtonCell = @"logoutCell";

@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.tintColor = [UIColor redColor];

    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCellXib"];
    
    self.userNameLabel.text = [[PFUser currentUser] objectForKey:@"userRealName"];
//    self.tableView.delegate = self;
//    [[GameController sharedInstance] gamesUserIsGoingTo:^{
//        [self.tableView reloadData];
//    }];
    
    //self.userNameLabel.text = [PFUser currentUser];
    
    if ( [UserProfilePicController sharedInstance].profilePicImageView.image == nil) {
        self.profilePic.image = [UIImage imageNamed:@"user60(resized)"];
    } else {
        self.profilePic.image = [UserProfilePicController sharedInstance].profilePicImageView.image;

    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    };
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];

    [[GameConfirmationController sharedInstance] gamesGoingTo:[PFUser currentUser] withCompletion:^(BOOL success) {
        NSLog(@"GAMESGOING QUERY");
        [self.tableView reloadData];
    }];
    
    [[GameController sharedInstance] getGamesfromUser:^{
        [self.tableView reloadData];
    }];
    
   

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case profileSectionsAddGame:
            return 1;
            break;
        case profileSectionsGamesPosted:
            return [GameController sharedInstance].gamesFromUser.count;
            break;
        case profileSectionsGamesGoing:
            return [GameConfirmationController sharedInstance].gamesUserIsGoingTo.count;
            break;
        case profileSectionsLogOut:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    Game *game;
    
    switch (indexPath.section) {
        case profileSectionsAddGame:
            return cell = [tableView dequeueReusableCellWithIdentifier:kAddGameCell];
            break;
        case profileSectionsGamesPosted:{

            game = [GameController sharedInstance].gamesFromUser[indexPath.row];
            CustomTableViewCell *customCell = [self.tableView dequeueReusableCellWithIdentifier:@"CustomCellXib"];
            customCell.sportName.text = game.sportName;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM dd, hh:mm a"];
            customCell.dateAndTime.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:game.dateAndTime]];
            
            customCell.city.text = game.city;
            return customCell;
        }
            break;
        case profileSectionsGamesGoing:{
            game = [[GameConfirmationController sharedInstance].gamesUserIsGoingTo[indexPath.row] objectForKey:@"game"];
            CustomTableViewCell *customCell = [self.tableView dequeueReusableCellWithIdentifier:@"CustomCellXib"];
            
            customCell.sportName.text = game.sportName;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM dd, hh:mm a"];
            customCell.dateAndTime.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:game.dateAndTime]];
            
            if (game) {
                customCell.city.text = game.city;
            }
            
            return customCell;
        }
            break;
        case profileSectionsLogOut:
            return [tableView dequeueReusableCellWithIdentifier:kLogOutButtonCell];
        default:
            return cell;
            break;
    }
}

//CustomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CustomCellXib"];
//
//Game *game = self.filteredGames[indexPath.row];
//
//cell.sportName.text = game.sportName;
//NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//[formatter setDateFormat:@"MMMM dd, hh:mm a"];
//cell.dateAndTime.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:game.dateAndTime]];
//
//cell.city.text = game.city;
//
//return cell;

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case profileSectionsGamesPosted:
           return @"Games Posted";
            break;
         case profileSectionsGamesGoing:
            return @"Games You're Going To";
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (indexPath.section == profileSectionsGamesGoing | indexPath.section == profileSectionsGamesPosted) {
        
       [self performSegueWithIdentifier:@"showGameFromProfilePage" sender:[tableView cellForRowAtIndexPath:indexPath]];
        
    }
    
    if (indexPath.section == profileSectionsLogOut) {
        [PFUser logOut];
        [self.navigationController.tabBarController setSelectedIndex:0];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == profileSectionsGamesGoing | section == profileSectionsGamesPosted) {
        return 30;
    } else {
        return 0;
    }

    return tableView.sectionHeaderHeight;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showGameFromProfilePage"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        
        if (indexPath.section == profileSectionsGamesGoing) {
            GameDetailViewController *VC = [segue destinationViewController];
            VC.game = [[GameConfirmationController sharedInstance].gamesUserIsGoingTo[indexPath.row] objectForKey:@"game"];
        }
        if (indexPath.section == profileSectionsGamesPosted) {
            GameDetailViewController *VC = [segue destinationViewController];
            VC.game = [GameController sharedInstance].gamesFromUser[indexPath.row];
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindToUserProfile:(UIStoryboardSegue *)segue {
    
}

- (IBAction)logoutButtonTapped:(id)sender {
    [PFUser logOutInBackground];
}

- (IBAction)addProfileImageButtonTapped:(id)sender {
    [self presentPhotoChoice];
}

- (void)presentPhotoChoice {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhoto];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Select Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhoto];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil ]];
    
    [self.tabBarController presentViewController:alertController animated:YES completion:nil];
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    //    self.dishPicture = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [[UIImage alloc]init];
        image = info[UIImagePickerControllerEditedImage];
        self.profilePic.image = image;
        
        [[UserProfilePicController sharedInstance] savePhotoForUser:[PFUser currentUser] profilePic:image];
       

        
        }];
    [[UserProfilePicController sharedInstance] getProfilePics:[PFUser currentUser] withCompletion:^(UserProfilePic *userProfilePic) {
        NSLog(@"PROFILE PIC UPDATED!");
    }];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == profileSectionsAddGame | indexPath.section == profileSectionsLogOut) {
        return NO;
    }
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == profileSectionsGamesGoing) {

            GameConfirmation *gameToBeDeleted = [GameConfirmationController sharedInstance].gamesUserIsGoingTo[indexPath.row];
            [[GameConfirmationController sharedInstance] deleteGameConfirmation:gameToBeDeleted];
            
            [[GameConfirmationController sharedInstance] gamesGoingTo:[PFUser currentUser] withCompletion:^(BOOL success) {
                if (success) {
                        [self.tableView reloadData];
                }
            }];
        }
        if (indexPath.section == profileSectionsGamesPosted) {
            Game *gameToBeDeleted = [GameController sharedInstance].gamesFromUser[indexPath.row];
            [[GameController sharedInstance] deleteGameUserPosted:gameToBeDeleted];
            
            [[GameController sharedInstance] getGames:^(BOOL success) {
                if (success) {
                    [self.tableView reloadData];
                }
            }];
        }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
