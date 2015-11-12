//
//  BZRShareCodeController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 23.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRShareCodeController.h"
#import "BZRSignUpController.h"
#import "BZRDashboardController.h"
#import "BZRForgotPasswordController.h"
#import "BZRBaseNavigationController.h"

#import "BZRFacebookService.h"
#import "BZRProjectFacade.h"

#import "BZRFacebookProfile.h"

#import "BZRCommonDateFormatter.h"

#import "BZRErrorHandler.h"

@interface BZRShareCodeController ()

@end

@implementation BZRShareCodeController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)skipClick:(id)sender
{
    [self moveToNextControllerOrPerformFacebookAuthorization];
}

- (IBAction)submitClick:(id)sender
{
    [self submitShareCode];
}

/**
 *  Push SignUpWithEmail controller to navigation stack when we are done with share code
 */
- (void)moveToNextControllerOrPerformFacebookAuthorization
{
    if (self.isFacebookFlow) {
        
        [self authorizeWithFacebook];
        
    } else {
        BZRSignUpController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSignUpController class])];
        controller.temporaryProfile = self.temporaryProfile;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/**
 *  Submit share code (send it to server)
 */
- (void)submitShareCode
{
    UITextField *shareCodeField = self.userNameField; //userNameField - textField from baseAuthController. In this place it describes the shareCodeField;
    WEAK_SELF;
    [BZRValidator validateShareCodeField:shareCodeField onSuccess:^{
        
        //TODO: Send request with Share Code
        [weakSelf moveToNextControllerOrPerformFacebookAuthorization];
        
    } onFailure:^(NSMutableDictionary *errorDict) {
        
        NSString *errorTitle = errorDict[kValidationErrorTitle];
        NSString *errorMessage = errorDict[kValidationErrorMessage];
        [BZRAlertFacade showAlertWithTitle:errorTitle andMessage:errorMessage forController:nil withCompletion:nil];
        [BZRValidator cleanValidationErrorDict];
        
    }];
}

/**
 *  Customize navigation item
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.view layoutIfNeeded];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = LOCALIZED(@"Share Code");
}

/**
 *  Customize cfurrent auth fields
 */
- (void)customizeFields
{
    [super customizeFields];
    [self.userNameField addBottomBorder];
}

/**
 *  Perform facebook authorization
 */
- (void)authorizeWithFacebook
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BZRFacebookService authorizeWithFacebookFromController:self onSuccess:^(BOOL isSuccess) {
        
        [BZRFacebookService getFacebookUserProfileOnSuccess:^(BZRFacebookProfile *facebookProfile) {
            
            NSString *email = facebookProfile.email ? facebookProfile.email : @"";
            
            [BZRProjectFacade signUpWithFacebookWithUserFirstName:weakSelf.temporaryProfile.firstName andUserLastName:weakSelf.temporaryProfile.lastName andEmail:email andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.temporaryProfile.dateOfBirth] andGender:[weakSelf.temporaryProfile.genderString substringToIndex:1] onSuccess:^(BOOL isSuccess) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                //detect success login with facebook
                [BZRFacebookService setLoginSuccess:YES];
                //go to dashboard
                BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
                controller.updateNeeded = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
                
            } onFailure:^(NSError *error, BOOL isCanceled) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                BOOL isFacebookEmailAlreadyRegistered = [BZRErrorHandler isFacebookEmailAlreadyExistFromError:error];
                
                if (isFacebookEmailAlreadyRegistered) {
                    [BZRAlertFacade showEmailAlreadyRegisteredAlertWithError:error forController:weakSelf andCompletion:^{
                        BZRForgotPasswordController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRForgotPasswordController class])];
                        controller.userName = weakSelf.userNameField.text;
                        BZRBaseNavigationController *navController = [[BZRBaseNavigationController alloc] initWithRootViewController:controller];
                        [weakSelf presentViewController:navController animated:YES completion:nil];
                    }];
                } else {
                    [BZRAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:nil];
                }
            }];
            
        } onFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userNameField isFirstResponder]) {
        [self.userNameField resignFirstResponder];
    }
    return YES;
}

@end
