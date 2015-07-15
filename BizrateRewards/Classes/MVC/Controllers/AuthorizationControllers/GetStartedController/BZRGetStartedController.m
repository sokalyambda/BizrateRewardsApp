//
//  BZRGetStartedController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetStartedController.h"
#import "BZRPrivacyAndTermsController.h"
#import "BZREditProfileContainerController.h"

#import "BZRValidator.h"
#import "BZRStorageManager.h"
#import "BZRTermsAndConditionsHelper.h"
#import "BZRCommonDateFormatter.h"

#import "BZRCheckBoxButton.h"
#import "BZREditProfileField.h"

#import "BZRUserProfile.h"

#import "UIView+Flashable.h"

static NSString *const kEditProfileContainerSegueIdentifier = @"editProfileContainerSegue";
static NSString *const kChooseSignUpTypeSegueIdentifier = @"сhooseSignUpTypeSegue";

@interface BZRGetStartedController ()<UITextFieldDelegate>

@property (weak, nonatomic) BZREditProfileContainerController *editProfileTableViewController;

@property (weak, nonatomic) IBOutlet BZRCheckBoxButton *privacyPolicyCheckBox;
@property (weak, nonatomic) IBOutlet BZRCheckBoxButton *termsCheckBox;
@property (weak, nonatomic) IBOutlet BZRCheckBoxButton *yearsCheckBox;

@property (strong, nonatomic) BZRValidator *validator;
@property (strong, nonatomic) BZRUserProfile *currentUserProfile;

@end

@implementation BZRGetStartedController

#pragma mark - Accessors

- (BZRValidator *)validator
{
    if (!_validator) {
        _validator = [BZRValidator sharedValidator];
    }
    return _validator;
}

- (BZRUserProfile *)currentUserProfile
{
    if (!_currentUserProfile) {
        _currentUserProfile = [BZRUserProfile userProfileFromDefaultsForKey:CurrentProfileKey];
    }
    
    return _currentUserProfile;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFieldsValueFromProfile];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"Get Started", nil);
}

#pragma mark - Actions

- (IBAction)privacyPolicyClick:(id)sender
{
    [BZRTermsAndConditionsHelper showPrivacyAndTermsWithType:BZRConditionsTypePrivacyPolicy andWithNavigationController:self.navigationController];
}

- (IBAction)termsAndConditionsClick:(id)sender
{
    [BZRTermsAndConditionsHelper showPrivacyAndTermsWithType:BZRConditionsTypeTermsAndConditions andWithNavigationController:self.navigationController];
}

- (IBAction)submitButtonClick:(UIButton *)sender
{
    if ([self.validator validateFirstNameField:self.editProfileTableViewController.firstNameField
                                lastNameField:self.editProfileTableViewController.lastNameField
                                   emailField:self.editProfileTableViewController.emailField
                             dateOfBirthField:self.editProfileTableViewController.dateOfBirthField
                                   genderField:self.editProfileTableViewController.genderField] && [self.validator validateCheckboxes:@[self.privacyPolicyCheckBox, self.termsCheckBox, self.yearsCheckBox]]) {
        
        [self createNewProfile];
        
        [self performSegueWithIdentifier:kChooseSignUpTypeSegueIdentifier sender:self];
        
    } else {
//        ShowAlert(self.validator.validationErrorString);
        [self.validator cleanValidationErrorString];
    }
}

- (void)createNewProfile
{
    //first step in user creation
    self.currentUserProfile = [[BZRUserProfile alloc] init];
    
    self.currentUserProfile.firstName = self.editProfileTableViewController.firstNameField.text;
    self.currentUserProfile.lastName = self.editProfileTableViewController.lastNameField.text;
    self.currentUserProfile.genderString = self.editProfileTableViewController.genderField.text;
    self.currentUserProfile.email = self.editProfileTableViewController.emailField.text;
    self.currentUserProfile.dateOfBirth = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:self.editProfileTableViewController.dateOfBirthField.text];
    
    [self.currentUserProfile setUserProfileToDefaultsForKey:CurrentProfileKey];
}

- (void)setupFieldsValueFromProfile
{
    self.editProfileTableViewController.firstNameField.text = self.currentUserProfile.firstName;
    self.editProfileTableViewController.lastNameField.text = self.currentUserProfile.lastName;
    self.editProfileTableViewController.emailField.text = self.currentUserProfile.email;
    self.editProfileTableViewController.genderField.text = self.currentUserProfile.genderString;
    self.editProfileTableViewController.dateOfBirthField.text = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:self.currentUserProfile.dateOfBirth];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditProfileContainerSegueIdentifier]) {
        self.editProfileTableViewController = (BZREditProfileContainerController *)segue.destinationViewController;
        [self.editProfileTableViewController viewWillAppear:YES];
    }
}

@end
