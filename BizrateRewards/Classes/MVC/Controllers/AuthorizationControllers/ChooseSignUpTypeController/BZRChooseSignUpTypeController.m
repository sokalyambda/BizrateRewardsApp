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

#import "BZRFacebookService.h"

#import "BZRProjectFacade.h"

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
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAccountPage propertyValue:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Actions

- (IBAction)closeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpWithFacebookClick:(id)sender
{
    [self signUpWithFacebook];
}

- (IBAction)signUpWithEmailClick:(id)sender
{
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked propertyValue:kAuthTypeEmail];
    [self performSegueWithIdentifier:kSignUpWithEmailSegueIdentifier sender:self];
}

/**
 *  Create new Bizrate-Facebook user with existed facebook account
 */
- (void)signUpWithFacebook
{
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked propertyValue:kAuthTypeFacebook];
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BZRFacebookService authorizeWithFacebookOnSuccess:^(BOOL isSuccess) {
        
        [BZRFacebookService getFacebookUserProfileOnSuccess:^(BZRFacebookProfile *facebookProfile) {
            
            NSString *email = facebookProfile.email ? facebookProfile.email : weakSelf.temporaryProfile.email;
            
            [BZRProjectFacade signUpWithFacebookWithUserFirstName:weakSelf.temporaryProfile.firstName andUserLastName:weakSelf.temporaryProfile.lastName andEmail:email andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.temporaryProfile.dateOfBirth] andGender:[self.temporaryProfile.genderString substringToIndex:1] onSuccess:^(BOOL isSuccess) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                //detect success login with facebook
                [BZRFacebookService setLoginSuccess:YES];
                //go to dashboard
                BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
                controller.updateNeeded = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
                
            } onFailure:^(NSError *error, BOOL isCanceled) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
            }];
            
        } onFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSignUpWithEmailSegueIdentifier]) {
        BZRSignUpController *controller = (BZRSignUpController *)segue.destinationViewController;
        controller.temporaryProfile = self.temporaryProfile;
    }
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
