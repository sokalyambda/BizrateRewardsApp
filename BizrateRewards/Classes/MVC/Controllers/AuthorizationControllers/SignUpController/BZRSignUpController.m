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

@property (strong, nonatomic) BZRUserProfile *currentUserProfile;

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
    if ([self.validator validateEmailField:self.userNameField andPasswordField:self.passwordField]) {
        [BZRReachabilityHelper checkConnectionOnSuccess:^{
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf.dataManager getClientCredentialsOnSuccess:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
                if (success) {
                    
                    [weakSelf.dataManager signUpWithUserFirstName:weakSelf.currentUserProfile.firstName
                                                  andUserLastName:weakSelf.currentUserProfile.lastName
                                                         andEmail:weakSelf.currentUserProfile.email
                                                      andPassword:weakSelf.passwordField.text
                                                   andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.currentUserProfile.dateOfBirth]
                                                        andGender:[weakSelf.currentUserProfile.genderString substringToIndex:1]
                                                       withResult:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
                                                           [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                           if (!success) {
                                                               ShowFailureResponseAlertWithError(error);
                                                           } else {
                                                               [weakSelf deleteTemporaryProfileFromDefaults];
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
    [self.passwordField addBottomBorder];
}

- (void)setupUserDataToFields
{
    self.userNameField.text = self.currentUserProfile.email;
}

- (void)deleteTemporaryProfileFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults.dictionaryRepresentation.allKeys containsObject:CurrentProfileKey]) {
        [defaults removeObjectForKey:CurrentProfileKey];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userNameField isFirstResponder]) {
        [self.passwordField becomeFirstResponder];
    } else if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
    return YES;
}

@end
