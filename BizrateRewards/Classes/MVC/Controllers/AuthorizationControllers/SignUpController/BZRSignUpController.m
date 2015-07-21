//
//  BZRSignUpController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignUpController.h"
#import "BZRDashboardController.h"

#import "BZRStorageManager.h"
#import "BZRCommonDateFormatter.h"

#import "BZRUserProfile.h"

#import "BZRAuthorizationService.h"

@interface BZRSignUpController ()

@property (weak, nonatomic) IBOutlet BZRAuthorizationField *confirmPasswordField;

@end

@implementation BZRSignUpController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = NSLocalizedString(@"Create Account with Email", nil);
    [self customizeFields];
    [self setupUserDataToFields];
}

#pragma mark - Actions

- (IBAction)createAccountClick:(id)sender
{
    WEAK_SELF;
    if ([self.validator validateEmailField:self.userNameField andPasswordField:self.passwordField andConfirmPasswordField:self.confirmPasswordField]) {
        
        self.temporaryProfile.email = self.userNameField.text;
        
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [BZRAuthorizationService signUpWithUserFirstName:weakSelf.temporaryProfile.firstName
                                         andUserLastName:weakSelf.temporaryProfile.lastName
                                                andEmail:weakSelf.temporaryProfile.email
                                             andPassword:self.passwordField.text
                                          andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.temporaryProfile.dateOfBirth]
                                               andGender:[weakSelf.temporaryProfile.genderString substringToIndex:1] onSuccess:^(BZRApplicationToken *token) {
                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                   BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
                                                   controller.updateNeeded = YES;
                                                   [weakSelf.navigationController pushViewController:controller animated:YES];
                                               } onFailure:^(NSError *error) {
                                                   ShowFailureResponseAlertWithError(error);
                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                               }];
    } else {
//        ShowAlert(self.validator.validationErrorString);
        [self.validator cleanValidationErrorString];
    }
}

- (void)customizeFields
{
    [super customizeFields];
    [self.confirmPasswordField addBottomBorder];
    self.confirmPasswordField.activeImageName      = @"password_icon_prepop";
    self.confirmPasswordField.notActiveImageName   = @"password_icon";
}

- (void)setupUserDataToFields
{
    self.userNameField.text = self.temporaryProfile.email;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userNameField isFirstResponder]) {
        [self.passwordField becomeFirstResponder];
    } else if ([self.passwordField isFirstResponder]) {
        [self.confirmPasswordField becomeFirstResponder];
    } else if ([self.confirmPasswordField isFirstResponder]) {
        [self.confirmPasswordField resignFirstResponder];
    }
    return YES;
}

@end
