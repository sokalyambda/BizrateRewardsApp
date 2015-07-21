//
//  BZRProfileSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZREditProfileController.h"
#import "BZREditProfileContainerController.h"

#import "BZRValidator.h"
#import "BZRCommonDateFormatter.h"
#import "BZRSerialViewConstructor.h"

#import "BZRStorageManager.h"

#import "BZRUserProfileService.h"

#import "BZREditProfileField.h"

static NSString *const kEditProfileContainerSegueIdentifier = @"editProfileContainerSegue";

@interface BZREditProfileController ()

@property (weak, nonatomic) BZREditProfileContainerController *container;

@property (strong, nonatomic) BZRValidator *validator;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@end

@implementation BZREditProfileController

#pragma mark - Accessors

- (BZRValidator *)validator
{
    if (!_validator) {
        _validator = [BZRValidator sharedValidator];
    }
    return _validator;
}

- (BZRUserProfile *)currentProfile
{
    _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    return _currentProfile;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFieldsValueFromProfile];
    [self customizeNavigationItem];
}

#pragma mark - Actions

- (void)doneClick:(id)sender
{
    [self updateUser];
}

- (void)customizeNavigationItem
{
    self.navigationItem.title = NSLocalizedString(@"Profile", nil);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = [BZRSerialViewConstructor customDoneButtonForController:self withAction:@selector(doneClick:)];
}

- (void)updateUser
{
    WEAK_SELF;
    if ([self.validator validateFirstNameField:self.container.firstNameField
                                 lastNameField:self.container.lastNameField
                                    emailField:self.container.emailField
                              dateOfBirthField:self.container.dateOfBirthField
                                   genderField:self.container.genderField]) {
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [BZRUserProfileService updateCurrentUserWithFirstName:self.container.firstNameField.text andLastName:self.container.lastNameField.text andDateOfBirth:self.container.dateOfBirthField.text andGender:[self.container.genderField.text substringToIndex:1] onSuccess:^(BZRUserProfile *userProfile) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } onFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            ShowFailureResponseAlertWithError(error);
        }];
    } else {
//        ShowAlert(self.validator.validationErrorString);
        [self.validator cleanValidationErrorString];
    }
}

- (void)setupFieldsValueFromProfile
{
    self.container.firstNameField.text  = self.currentProfile.firstName;
    self.container.lastNameField.text   = self.currentProfile.lastName;
    self.container.emailField.text      = self.currentProfile.email;
    self.container.genderField.text     = self.currentProfile.genderString;
    self.container.dateOfBirthField.text = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:self.currentProfile.dateOfBirth];
    
    self.container.emailField.userInteractionEnabled = NO;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditProfileContainerSegueIdentifier]) {
        self.container = (BZREditProfileContainerController *)segue.destinationViewController;
        self.container.scrollNeeded = NO;
        [self.container viewWillAppear:YES];
    }
}

@end
