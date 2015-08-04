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

@interface BZRForgotPasswordController ()

@end

@implementation BZRForgotPasswordController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
        
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        
        BZRConfirmPasswordController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRConfirmPasswordController class])];
        [weakSelf.navigationController pushViewController:controller animated:YES];
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        //TODO: forgot password request
    } onFailure:^(NSString *errorString) {
        [BZRValidator cleanValidationErrorString];
    }];
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
