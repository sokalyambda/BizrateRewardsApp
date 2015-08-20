//
//  BZRForgotPasswordController.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRForgotPasswordController.h"
#import "BZRConfirmPasswordController.h"

#import "BZRValidator.h"

#import "BZRProjectFacade.h"

@interface BZRForgotPasswordController ()

@end

@implementation BZRForgotPasswordController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self clearNewResettingPasswordRequirement];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setupEmailIfExists];
}

#pragma mark - Actions

- (IBAction)exitClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetPasswordClick:(id)sender
{
    WEAK_SELF;
    [BZRValidator validateEmailField:self.userNameField andPasswordField:self.passwordField onSuccess:^{
        [weakSelf resignIfFirstResponder];
        [weakSelf resetPassword];
    } onFailure:^(NSMutableDictionary *errorDict) {
        [BZRValidator cleanValidationErrorDict];
    }];
}

/**
 *  If 'resettingPasswordRepeatNeeded' is 'YES' - set it to 'NO', cause user has already seen this screen.
 */
- (void)clearNewResettingPasswordRequirement
{
    if ([BZRStorageManager sharedStorage].resettingPasswordRepeatNeeded) {
        [BZRStorageManager sharedStorage].resettingPasswordRepeatNeeded = NO;
    }
}

/**
 *  Call reset password request
 */
- (void)resetPassword
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BZRProjectFacade resetPasswordWithUserName:self.userNameField.text andNewPassword:self.passwordField.text onSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        BZRConfirmPasswordController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRConfirmPasswordController class])];
        [weakSelf.navigationController pushViewController:controller animated:YES];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

- (void)setupEmailIfExists
{
    if (self.userName.length) {
        self.userNameField.text = self.userName;
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

/**
 *  Set default status bar style because the background is white
 *
 *  @return UIStatusBarStyleDefault
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
