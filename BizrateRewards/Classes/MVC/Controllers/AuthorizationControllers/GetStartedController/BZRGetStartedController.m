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

@property (strong, nonatomic) BZRUserProfile *temporaryProfile;

@end

@implementation BZRGetStartedController

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
    WEAK_SELF;
    [BZRValidator validateFirstNameField:self.editProfileTableViewController.firstNameField
                           lastNameField:self.editProfileTableViewController.lastNameField
                              emailField:self.editProfileTableViewController.emailField
                        dateOfBirthField:self.editProfileTableViewController.dateOfBirthField
                             genderField:self.editProfileTableViewController.genderField
                           andCheckboxes:@[self.privacyPolicyCheckBox, self.termsCheckBox, self.yearsCheckBox]
                               onSuccess:^{
                                   
                                   [weakSelf createNewTemporaryProfile];
                                   
                                   [weakSelf performSegueWithIdentifier:kChooseSignUpTypeSegueIdentifier sender:weakSelf];
        
    }
                               onFailure:^(NSString *errorString) {
                                   [BZRValidator cleanValidationErrorString];
    }];
}

- (void)createNewTemporaryProfile
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
        self.editProfileTableViewController.scrollNeeded = YES;
        [self.editProfileTableViewController viewWillAppear:YES];
    } else if ([segue.identifier isEqualToString:kChooseSignUpTypeSegueIdentifier]) {
        BZRChooseSignUpTypeController *controller = (BZRChooseSignUpTypeController *)segue.destinationViewController;
        controller.temporaryProfile = self.temporaryProfile;
    }
}

@end
