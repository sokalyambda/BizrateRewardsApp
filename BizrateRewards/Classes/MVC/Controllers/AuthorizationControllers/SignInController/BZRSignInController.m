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

@interface BZRSignInController ()

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
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.dataManager authorizeWithFacebookWithResult:^(BOOL success, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (success) {
            [weakSelf performSegueWithIdentifier:kDashboardSegueIdentifier sender:weakSelf];
        }
    }];
}

//email
- (IBAction)signInClick:(id)sender
{
    WEAK_SELF;
    if ([self.validator validateEmailField:self.userNameField andPasswordField:self.passwordField]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.dataManager signInWithUserName:self.userNameField.text password:self.passwordField.text withResult:^(BOOL success, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            if (!success) {
                ShowErrorAlert(error);
            } else {
                [weakSelf performSegueWithIdentifier:kDashboardSegueIdentifier sender:weakSelf];
            }
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

@end
