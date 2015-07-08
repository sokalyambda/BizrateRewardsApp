//
//  BZRSignInController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignInController.h"

#import "BZRDataManager.h"

#import "BZRLeftImageTextField.h"

static NSString *const kDashboardSegueIdentifier = @"dashboardSegue";

@interface BZRSignInController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BZRLeftImageTextField *userNameField;
@property (weak, nonatomic) IBOutlet BZRLeftImageTextField *passwordField;

@property (strong, nonatomic) BZRDataManager *dataManager;

@end

@implementation BZRSignInController

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

//facebook
- (IBAction)facebookLoginClick:(id)sender
{
    
}

//email
- (IBAction)signInClick:(id)sender
{
    WEAK_SELF;
    if ([self.validator validateEmailField:self.userNameField andPasswordField:self.passwordField]) {
        [BZRReachabilityHelper checkConnectionOnSuccess:^{
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf.dataManager signInWithUserName:weakSelf.userNameField.text password:weakSelf.passwordField.text withResult:^(BOOL success, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (!success) {
                    ShowErrorAlert(error);
                } else {
                    [weakSelf performSegueWithIdentifier:kDashboardSegueIdentifier sender:weakSelf];
                }
            }];
        } failure:^{
            ShowAlert(InternetIsNotReachableString);
        }];
        
    } else {
        ShowAlert(self.validator.validationErrorString);
        [self.validator cleanValidationErrorString];
    }
}

- (IBAction)rememberMeClick:(id)sender
{

}

- (IBAction)forgotPasswordClick:(id)sender
{
    
}

- (void)customizeFields
{
    self.userNameField.imageName = @"email_icon";
    self.passwordField.imageName = @"password_icon";
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
