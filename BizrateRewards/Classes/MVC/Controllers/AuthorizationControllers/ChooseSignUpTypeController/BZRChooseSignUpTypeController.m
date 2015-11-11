//
//  BZRChooseSignUpTypeController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRChooseSignUpTypeController.h"
#import "BZRShareCodeController.h"

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
    [self moveToShareCodeControllerFromFacebookFlow:NO];
}

/**
 *  Create new Bizrate-Facebook user with existed facebook account
 */
- (void)signUpWithFacebook
{
    [self moveToShareCodeControllerFromFacebookFlow:YES];
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
