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
                                                               ShowErrorAlert(error);
                                                               
                                                               NSData *errData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                                                               NSString *errString = [[NSString alloc] initWithData:errData encoding:NSUTF8StringEncoding];
                                                               NSLog(@"errString: %@", errString);
                                                               
                                                           } else {
                                                               NSLog(@"profile has been created");
                                                               BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
                                                               controller.updateNeeded = YES;
                                                               [weakSelf.navigationController pushViewController:controller animated:YES];
                                                           }
                    }];
                    
                } else {
                    ShowErrorAlert(error);
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                }
            }];
        } failure:^{
            
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
