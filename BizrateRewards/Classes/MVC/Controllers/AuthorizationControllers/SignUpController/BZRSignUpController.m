//
//  BZRSignUpController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignUpController.h"
#import "BZRDashboardController.h"
#import "BZRForgotPasswordController.h"
#import "BZRBaseNavigationController.h"

#import "BZRCommonDateFormatter.h"

#import "BZRProjectFacade.h"

#import "BZRErrorHandler.h"
#import "BZRKeychainHandler.h"

@interface BZRSignUpController ()

@property (weak, nonatomic) IBOutlet BZRAuthorizationField *confirmPasswordField;

@end

@implementation BZRSignUpController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupUserDataToFields];
}

#pragma mark - Actions

- (IBAction)createAccountClick:(id)sender
{
    [self signUpWithEmail];
}

/**
 *  Validate fields and create new user profile, using user's email (on success)
 */
- (void)signUpWithEmail
{
    WEAK_SELF;
    [BZRValidator validateEmailField:self.userNameField
                    andPasswordField:self.passwordField
             andConfirmPasswordField:self.confirmPasswordField
                           onSuccess:^{
                               [weakSelf resignIfFirstResponder];
                               
                               weakSelf.temporaryProfile.email = weakSelf.userNameField.text;
                               
                               [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                               
                               [BZRProjectFacade signUpWithUserFirstName:weakSelf.temporaryProfile.firstName andUserLastName:weakSelf.temporaryProfile.lastName andEmail:weakSelf.temporaryProfile.email andPassword:weakSelf.passwordField.text andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.temporaryProfile.dateOfBirth] andGender:[weakSelf.temporaryProfile.genderString substringToIndex:1]andShareCode:weakSelf.temporaryProfile.shareCode success:^(BOOL success) {
                                   
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                   
                                   [BZRKeychainHandler storeCredentialsWithUsername:weakSelf.userNameField.text andPassword:weakSelf.passwordField.text forService:UserCredentialsKey];
                                   
                                   BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
                                   controller.updateNeeded = YES;
                                   [weakSelf.navigationController pushViewController:controller animated:YES];
                                   
                               } failure:^(NSError *error, BOOL isCanceled) {
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                   
                                   BOOL isEmailAlreadyRegistered = [BZRErrorHandler isEmailAlreadyExistFromError:error];
                                   
                                   if (isEmailAlreadyRegistered) {
                                       [BZRAlertFacade showEmailAlreadyRegisteredAlertWithError:error forController:weakSelf andCompletion:^{
                                           BZRForgotPasswordController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRForgotPasswordController class])];
                                           controller.userName = weakSelf.userNameField.text;
                                           BZRBaseNavigationController *navController = [[BZRBaseNavigationController alloc] initWithRootViewController:controller];
                                           [weakSelf presentViewController:navController animated:YES completion:nil];
                                       }];
                                   } else {
                                       [BZRAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:^{
                                           
                                       }];
                                   }
                               }];
                           }
                           onFailure:^(NSMutableDictionary *errorDict) {
                               NSString *errorTitle = errorDict[kValidationErrorTitle];
                               NSString *errorMessage = errorDict[kValidationErrorMessage];
                               [BZRAlertFacade showAlertWithTitle:errorTitle andMessage:errorMessage forController:nil withCompletion:nil];
                               [BZRValidator cleanValidationErrorDict];
                           }];
}

/**
 *  Customize current auth fields
 */
- (void)customizeFields
{
    [super customizeFields];
    [self.confirmPasswordField addBottomBorder];
    self.confirmPasswordField.activeImageName      = @"password_icon_prepop";
    self.confirmPasswordField.notActiveImageName   = @"password_icon";
}

/**
 *  Customize navigation item
 */
- (void)customizeNavigationItem
{
    [self.view layoutIfNeeded];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = LOCALIZED(@"Create Account with Email");
}

/**
 *  Setup email data to text fields relative to current temporary profile
 */
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
        //sign up on done click
        [self signUpWithEmail];
    }
    return YES;
}

@end
