//
//  BZRChooseSignUpTypeController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRChooseSignUpTypeController.h"
#import "BZRSignUpController.h"
#import "BZRDashboardController.h"

#import "BZRAuthorizationService.h"
#import "BZRUserProfileService.h"

#import "BZRStorageManager.h"

#import "BZRCommonDateFormatter.h"

static NSString *const kSignUpWithEmailSegueIdentifier = @"signUpWithEmailSegue";

static NSString *const kEmail = @"email";

@interface BZRChooseSignUpTypeController ()

@end

@implementation BZRChooseSignUpTypeController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAccountPage properties:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Actions

- (IBAction)signUpWithFacebookClick:(id)sender
{
//    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked properties:@{Type: AuthTypeFacebook}];
//    
//    WEAK_SELF;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [BZRAuthorizationService authorizeWithFacebookAccountOnSuccess:^(FBSDKLoginManagerLoginResult *loginResult) {
//
//        [BZRUserProfileService getFacebookUserProfileOnSuccess:^(NSDictionary *facebookProfile) {
//            
//            NSString *email = facebookProfile[kEmail] ? facebookProfile[kEmail] : self.temporaryProfile.email;
//            
//            NSString *facebookToken = [BZRStorageManager sharedStorage].facebookToken.tokenString;
//            
//            [BZRAuthorizationService signUpWithUserFirstName:self.temporaryProfile.firstName
//                                             andUserLastName:self.temporaryProfile.lastName
//                                                    andEmail:email
//                                                 andPassword:nil
//                                              andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:self.temporaryProfile.dateOfBirth]
//                                                   andGender:[self.temporaryProfile.genderString substringToIndex:1]
//                                            andFacebookToken:facebookToken
//                                                   onSuccess:^(BZRApplicationToken *token) {
//                                                       
//                                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//                                                       
//                                                       [BZRMixpanelService trackEventWithType:BZRMixpanelEventRegistrationSuccessful properties:@{Type : AuthTypeFacebook}];
//                                                       
//                                                       BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
//                                                       controller.updateNeeded = YES;
//                                                       [weakSelf.navigationController pushViewController:controller animated:YES];
//                                                       
//                                                   }
//                                                   onFailure:^(NSError *error) {
//                                                       
//                                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//                                                       ShowFailureResponseAlertWithError(error);
//                                                   }];
//            
//        } onFailure:^(NSError *error) {
//            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//            ShowFailureResponseAlertWithError(error);
//        }];
//        
//    } onFailure:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        ShowFailureResponseAlertWithError(error);
//    }];
    
}

- (IBAction)signUpWithEmailClick:(id)sender
{
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked properties: @{Type: AuthTypeEmail}];
    [self performSegueWithIdentifier:kSignUpWithEmailSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSignUpWithEmailSegueIdentifier]) {
        BZRSignUpController *controller = (BZRSignUpController *)segue.destinationViewController;
        controller.temporaryProfile = self.temporaryProfile;
    }
}

@end
