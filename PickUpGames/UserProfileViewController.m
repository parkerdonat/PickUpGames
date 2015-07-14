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

static NSString * const kAddGameCell = @"addGameButtonCell";
static NSString * const kGamesPostedCell = @"gamesPostedCell";
static NSString * const kGamesGoingCell = @"gamesGoingCell";
static NSString * const kLogOutButtonCell = @"logoutCell";

@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.delegate = self;
//    [[GameController sharedInstance] gamesUserIsGoingTo:^{
//        [self.tableView reloadData];
//    }];
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
            cell = [tableView dequeueReusableCellWithIdentifier:kGamesPostedCell];
            cell.textLabel.text = game.sportName;
            return cell;
        }
            break;
        case profileSectionsGamesGoing:
            game = [[GameConfirmationController sharedInstance].gamesUserIsGoingTo[indexPath.row] objectForKey:@"to"];
            cell = [tableView dequeueReusableCellWithIdentifier:kGamesGoingCell];
            if (game) {
                cell.textLabel.text = game.sportName;
            }
            return cell;
            break;
        case profileSectionsLogOut:
            return [tableView dequeueReusableCellWithIdentifier:kLogOutButtonCell];
        default:
            return cell;
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case profileSectionsGamesPosted:
           return @"Games Posted";
            break;
         case profileSectionsGamesGoing:
            return @"Games You Are Going Too";
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
    switch (indexPath.section) {
        case profileSectionsLogOut:
            [PFUser logOut];
            [self.navigationController.tabBarController setSelectedIndex:0];
            break;
        default:
            break;
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
        
        self.imageButton.alpha = 0;
        
        [[UserProfilePicController sharedInstance] savePhotoForUser:[PFUser currentUser] profilePic:image];
        
        PFUser *user = [PFUser currentUser];
        [user setObject:[UserProfilePicController sharedInstance].profilePicObj forKey:@"profilePicPointer"];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
