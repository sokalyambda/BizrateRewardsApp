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
#import "BZRChooseSignUpTypeController.h"

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

@property (strong, nonatomic) BZRUserProfile *temporaryProfile;

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

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.temporaryProfile = [[BZRUserProfile alloc] init];
    
    self.temporaryProfile.firstName = self.editProfileTableViewController.firstNameField.text;
    self.temporaryProfile.lastName = self.editProfileTableViewController.lastNameField.text;
    self.temporaryProfile.genderString = self.editProfileTableViewController.genderField.text;
    self.temporaryProfile.email = self.editProfileTableViewController.emailField.text;
    self.temporaryProfile.dateOfBirth = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:self.editProfileTableViewController.dateOfBirthField.text];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditProfileContainerSegueIdentifier]) {
        self.editProfileTableViewController = (BZREditProfileContainerController *)segue.destinationViewController;
        [self.editProfileTableViewController viewWillAppear:YES];
    } else if ([segue.identifier isEqualToString:kChooseSignUpTypeSegueIdentifier]) {
        BZRChooseSignUpTypeController *controller = (BZRChooseSignUpTypeController *)segue.destinationViewController;
        controller.temporaryProfile = self.temporaryProfile;
    }
}

@end
