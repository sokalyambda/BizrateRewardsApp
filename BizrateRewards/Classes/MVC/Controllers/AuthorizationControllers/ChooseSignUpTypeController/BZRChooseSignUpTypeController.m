//
//  BZRChooseSignUpTypeController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRChooseSignUpTypeController.h"
#import "BZRShareCodeController.h"

//Temporary
#import "BZRSignUpController.h"
#import "BZRDashboardController.h"
#import "BZRForgotPasswordController.h"
#import "BZRBaseNavigationController.h"
#import "BZRFacebookService.h"
#import "BZRProjectFacade.h"
#import "BZRCommonDateFormatter.h"
#import "BZRErrorHandler.h"

@interface BZRChooseSignUpTypeController ()

@end

@implementation BZRChooseSignUpTypeController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAccountPage propertyValue:nil];
}

#pragma mark - Actions

- (IBAction)closeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpWithFacebookClick:(id)sender
{
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked propertyValue:kAuthTypeFacebook];
    [self signUpWithFacebook];
}

- (IBAction)signUpWithEmailClick:(id)sender
{
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked propertyValue:kAuthTypeEmail];
    
    BZRSignUpController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSignUpController class])];
    controller.temporaryProfile = self.temporaryProfile;
    [self.navigationController pushViewController:controller animated:YES];
    /*
     Commented because of version 1.0.1
     
     [self moveToShareCodeControllerFromFacebookFlow:NO];
     */
}

/**
 *  Create new Bizrate-Facebook user with existed facebook account
 */
- (void)signUpWithFacebook
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BZRFacebookService authorizeWithFacebookFromController:self onSuccess:^(BOOL isSuccess) {
        
        [BZRFacebookService getFacebookUserProfileOnSuccess:^(BZRFacebookProfile *facebookProfile) {
            
            NSString *email = facebookProfile.email ? facebookProfile.email : @"";
            
            [BZRProjectFacade signUpWithFacebookWithUserFirstName:weakSelf.temporaryProfile.firstName andUserLastName:weakSelf.temporaryProfile.lastName andEmail:email andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.temporaryProfile.dateOfBirth] andGender:[weakSelf.temporaryProfile.genderString substringToIndex:1] andShareCode:weakSelf.temporaryProfile.shareCode onSuccess:^(BOOL isSuccess) {
                
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
    /*
     Commented because of version 1.0.1
     
     [self moveToShareCodeControllerFromFacebookFlow:YES];
     */
}

/**
 *  Move to share code controller
 *
 *  @param facebookFlow BOOL value that describes whether user clicks facebook button or no
 */
- (void)moveToShareCodeControllerFromFacebookFlow:(BOOL)facebookFlow
{
    //move to share code controller, feature of version 2.0
    BZRShareCodeController *shareCodeController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRShareCodeController class])];
    shareCodeController.temporaryProfile = self.temporaryProfile;
    shareCodeController.facebookFlow = facebookFlow;
    [self.navigationController pushViewController:shareCodeController animated:YES];
}

/**
 *  Customize navigation item
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Navigation

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
