//
//  BZRShareCodeController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 23.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRShareCodeController.h"
#import "BZRSignUpController.h"

@interface BZRShareCodeController ()

@end

@implementation BZRShareCodeController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationItem];
}

#pragma mark - Actions

- (IBAction)skipClick:(id)sender
{
    [self moveToSignUpWithEmailController];
}

- (IBAction)submitClick:(id)sender
{
    [self submitShareCode];
}

/**
 *  Push SignUpWithEmail controller to navigation stack when we are done with share code
 */
- (void)moveToSignUpWithEmailController
{
    BZRSignUpController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSignUpController class])];
    controller.temporaryProfile = self.temporaryProfile;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  Submit share code (send it to server)
 */
- (void)submitShareCode
{
    //TODO: validation, request
    [self moveToSignUpWithEmailController];
}

/**
 *  Customize navigation item
 */
- (void)customizeNavigationItem
{
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userNameField isFirstResponder]) {
        [self.userNameField resignFirstResponder];
    }
    return YES;
}

@end
