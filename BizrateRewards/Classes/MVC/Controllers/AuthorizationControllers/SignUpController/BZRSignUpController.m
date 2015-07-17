//
//  BZRSignUpController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignUpController.h"
#import "BZRDashboardController.h"

#import "BZRDataManager.h"
#import "BZRStorageManager.h"
#import "BZRCommonDateFormatter.h"

#import "BZRUserProfile.h"

@interface BZRSignUpController ()

@property (strong, nonatomic) BZRDataManager *dataManager;

@property (weak, nonatomic) IBOutlet BZRAuthorizationField *confirmPasswordField;

@end

@implementation BZRSignUpController

#pragma mark - Accessors

- (BZRDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [BZRDataManager sharedInstance];
    }
    return _dataManager;
}

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
        [BZRReachabilityHelper checkConnectionOnSuccess:^{
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf.dataManager getClientCredentialsOnSuccess:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
                if (success) {
                    [weakSelf.dataManager signUpWithUserFirstName:weakSelf.temporaryProfile.firstName
                                                  andUserLastName:weakSelf.temporaryProfile.lastName
                                                         andEmail:weakSelf.temporaryProfile.email
                                                      andPassword:weakSelf.passwordField.text
                                                   andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.temporaryProfile.dateOfBirth]
                                                        andGender:[weakSelf.temporaryProfile.genderString substringToIndex:1]
                                                       withResult:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
                                                           [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                           if (!success) {
                                                               ShowFailureResponseAlertWithError(error);
                                                           } else {
                                                               BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
                                                               controller.updateNeeded = YES;
                                                               [weakSelf.navigationController pushViewController:controller animated:YES];
                                                           }
                    }];
                    
                } else {
                    ShowFailureResponseAlertWithError(error);
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                }
            }];
        } failure:^{
            ShowAlert(InternetIsNotReachableString);
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
