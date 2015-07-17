//
//  LoginViewController.m
//  PickUpGames
//
//  Created by Kaleo Kim on 6/22/15.
//  Copyright (c) 2015 Kaleo Kim. All rights reserved.
//

#import "RegisterPageViewController.h"

@interface RegisterPageViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *registerUserButton;

@end

@implementation RegisterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    self.registerUserButton.backgroundColor = [UIColor whiteColor];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerUser {

}


- (IBAction)createUserButtonTapped:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.email.text;
    user.password = self.password.text;
    user [@"userRealName"] = self.name.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [PFUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
                   [self performSegueWithIdentifier:@"unwindToHome" sender:nil];
            }];
//            [self dismissViewControllerAnimated:YES completion:nil];
         
        } else {  NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            
            NSLog(@"login error %@", errorString);
        }
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
