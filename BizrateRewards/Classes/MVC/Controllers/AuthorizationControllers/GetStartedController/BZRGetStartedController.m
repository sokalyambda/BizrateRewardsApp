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
#import "BZRTermsAndConditionsHelper.h"

static NSString *const kEditProfileContainerSegueIdentifier = @"editProfileContainerSegue";
static NSString *const kChooseSignUpTypeSegueIdentifier = @"сhooseSignUpTypeSegue";

@interface BZRGetStartedController ()<UITextFieldDelegate>

@property (weak, nonatomic) BZREditProfileContainerController *editProfileTableViewController;

@property (strong, nonatomic) BZRValidator *validator;

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

#pragma mark - Actions

- (IBAction)privacyPolicyClick:(id)sender
{
    [BZRTermsAndConditionsHelper showPrivacyAndTermsWithType:BZRConditionsTypePrivacyPolicy andWithNavigationController:self.navigationController];
}

- (IBAction)termsAndConditionsClick:(id)sender
{
    [BZRTermsAndConditionsHelper showPrivacyAndTermsWithType:BZRConditionsTypeTermsAndConditions andWithNavigationController:self.navigationController];
}

- (IBAction)submitButtonClick:(id)sender
{
//    if ([self.validator validateFirstNameField:self.editProfileTableViewController.firstNameField
//                                lastNameField:self.editProfileTableViewController.lastNameField
//                                   emailField:self.editProfileTableViewController.emailField
//                             dateOfBirthField:self.editProfileTableViewController.dateOfBirthField
//                                  genderField:self.editProfileTableViewController.genderField]) {
//        [self performSegueWithIdentifier:kChooseSignUpTypeSegueIdentifier sender:self];
//        
//    } else {
//        ShowAlert(self.validator.validationErrorString);
//        [self.validator cleanValidationErrorString];
//    }
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
