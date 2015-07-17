//
//  AddGameViewController.m
//  
//
//  Created by Kaleo Kim on 6/19/15.
//
//

#import "AddGameViewController.h"

@interface AddGameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *postGameButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *privatePublicSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *nameOfSportTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *whereTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateAndTimeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *sportImage;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak, nonatomic) IBOutlet UIImageView *whereImage;
@property (weak, nonatomic) IBOutlet UIImageView *dateTimeImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *publicOrNot;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *postGameBUtton;
@property (weak, nonatomic) IBOutlet UIButton *cancelGameButton;

@end

@implementation AddGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postGameBUtton.backgroundColor = [UIColor redColor];
    self.cancelGameButton.backgroundColor = [UIColor blueColor];
    self.nameOfSportTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.cityTextField.delegate = self;
    
    // Do any additional setup after loading the view.
    
//    self.sportImage.tintColor = [UIColor colorWithRed:0.137 green:0.349 blue:0.945 alpha:1];
//    self.cityImage.tintColor = [UIColor colorWithRed:0.137 green:0.349 blue:0.945 alpha:1];
//    self.whereImage.tintColor = [UIColor colorWithRed:0.137 green:0.349 blue:0.945 alpha:1];
//    self.dateTimeImage.tintColor = [UIColor colorWithRed:0.137 green:0.349 blue:0.945 alpha:1];
    self.sportImage.tintColor = [UIColor redColor];
    self.cityImage.tintColor = [UIColor redColor];
    self.whereImage.tintColor = [UIColor redColor];
    self.dateTimeImage.tintColor = [UIColor redColor];
    
    
    self.dateAndTimeTextField.delegate = self;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.dateAndTimeTextField) {
        [self initializeDateInputView];
    }
}

- (void) initializeDateInputView {
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)/2)];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 45)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *flexibleSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDatePicker:)];
    [toolbar setItems: @[cancelButton,flexibleSeparator, doneButton] animated:YES];
//    self.dateBeganTitle.inputAccessoryView = toolbar;
    self.dateAndTimeTextField.inputAccessoryView = toolbar;
    self.dateAndTimeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.dateAndTimeTextField.inputView = self.datePicker;
}

- (void) dateUpdated:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        [formatter setDateFormat:@"MMMM dd, hh:mm a"];
        self.dateAndTimeTextField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
}

- (void)cancelDatePicker:(id)sender {
    [self.dateAndTimeTextField resignFirstResponder];
    
    self.dateAndTimeTextField.text = @"";
    
}

- (void)doneButtonPressed:(id)sender {
    [self.dateAndTimeTextField resignFirstResponder];
}

- (IBAction)createGameButtonTapped:(id)sender {
    
    if (self.nameOfSportTextField && self.cityTextField && self.whereTextField && self.dateAndTimeTextField) {
        [[GameController sharedInstance] createGameWithName:self.nameOfSportTextField.text city:self.cityTextField.text where:self.whereTextField.text dateAndTime:self.datePicker.date creator:[PFUser currentUser]];
        
        self.nameOfSportTextField.text = @"";
        self.cityTextField.text = @"";
        self.whereTextField.text = @"";
        self.dateAndTimeTextField.text = @"";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
