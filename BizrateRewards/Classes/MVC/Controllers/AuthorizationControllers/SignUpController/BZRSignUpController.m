//
//  BZRSignUpController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignUpController.h"

#import "BZRDataManager.h"

@interface BZRSignUpController ()

@property (strong, nonatomic) BZRDataManager *dataManager;

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
    [self customizeFields];
}

#pragma mark - Actions

- (IBAction)createAccountClick:(id)sender
{
    WEAK_SELF;
    if ([self.validator validateEmailField:self.userNameField andPasswordField:self.passwordField]) {
        [BZRReachabilityHelper checkConnectionOnSuccess:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.dataManager getClientCredentialsOnSuccess:^(BOOL success, NSError *error) {
                if (success) {
                    [weakSelf.dataManager signUpWithUserFirstName:@"firstNameTest" andUserLastName:@"lastNameTest" andEmail:@"qweqweqwe@gmail.com" withResult:^(BOOL success, NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                        if (!success) {
                            ShowErrorAlert(error);
                        }
                    }];
                } else {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                }
            }];
        } failure:^{
            
        }];
    } else {
        ShowAlert(self.validator.validationErrorString);
        [self.validator cleanValidationErrorString];
    }
}

- (void)customizeFields
{
    [super customizeFields];
    [self.passwordField addBottomBorder];
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
