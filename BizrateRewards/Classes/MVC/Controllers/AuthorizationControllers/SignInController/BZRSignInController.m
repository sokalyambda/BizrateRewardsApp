//
//  BZRSignInController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignInController.h"
#import "BZRGetStartedController.h"
#import "BZRDashboardController.h"
#import "BZRForgotPasswordController.h"
#import "BZRBaseNavigationController.h"

#import "BZRKeychainHandler.h"

#import "BZRProjectFacade.h"

#import "BZRFacebookService.h"

static NSString *const kDashboardSegueIdentifier = @"dashboardSegue";

@interface BZRSignInController ()

@property (weak, nonatomic) IBOutlet UIView *incorrectEmailView;

@property (weak, nonatomic) IBOutlet UISwitch *rememberMeSwitch;

@property (assign, nonatomic, getter=isRememberMe) BOOL rememberMe;

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation BZRSignInController

@synthesize rememberMe = _rememberMe;

#pragma mark - Accessors

- (BOOL)isRememberMe
{
    return [self.defaults boolForKey:RememberMeKey];
}

- (void)setRememberMe:(BOOL)rememberMe
{
    _rememberMe = rememberMe;
    [self.defaults setBool:_rememberMe forKey:RememberMeKey];
    [self.defaults synchronize];
}

- (NSUserDefaults *)defaults
{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.rememberMeSwitch setOn:self.isRememberMe];
    [self getUserDataFromKeychain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = LOCALIZED(@"Login");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Actions

- (IBAction)facebookLoginClick:(id)sender
{
    //for case when we have existed FB credentials
    [BZRFacebookService logoutFromFacebook];
    
    //resign responder from active fields
    [self resignIfFirstResponder];
    
    //signIn with facebook
    [self signInWithFacebook];
}

- (IBAction)signInClick:(id)sender
{
    [self signInWithEmail];
}

- (IBAction)forgotPasswordClick:(id)sender
{
    [self showForgotPasswordController];
}

- (IBAction)goToCreateNewAccountClick:(id)sender
{
    BZRGetStartedController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRGetStartedController class])];
    controller.failedToSignInEmail = self.userNameField.text;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)rememberMeValueChanged:(id)sender
{
    self.rememberMe = !self.isRememberMe;
}

/**
 *  Present the forgot password controller
 */
- (void)showForgotPasswordController
{
    BZRForgotPasswordController *forgotPasswordController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRForgotPasswordController class])];
    BZRBaseNavigationController *navigationController = [[BZRBaseNavigationController alloc] initWithRootViewController:forgotPasswordController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/**
 *  Sign in with email
 */
- (void)signInWithEmail
{
    [self.incorrectEmailView setHidden:YES];
    WEAK_SELF;
    [BZRValidator validateEmailField:self.userNameField
                    andPasswordField:self.passwordField
                           onSuccess:^{
                               
                               [weakSelf resignIfFirstResponder];
                               
                               [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                               [BZRProjectFacade signInWithEmail:weakSelf.userNameField.text password:weakSelf.passwordField.text success:^(BOOL success) {
                                   //hide progress hud
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                   
//                                   if (weakSelf.isRememberMe) {
                                   [BZRKeychainHandler storeCredentialsWithUsername:weakSelf.userNameField.text andPassword:weakSelf.passwordField.text];
//                                   }
                                   [weakSelf performSegueWithIdentifier:kDashboardSegueIdentifier sender:weakSelf];
                                   
                               } failure:^(NSError *error, BOOL isCanceled, BOOL emailRegistered) {
                                   
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                   
                                   if (!emailRegistered) {
                                       [weakSelf.incorrectEmailView setHidden:NO];
                                       weakSelf.userNameField.errorImageName = kEmailErrorIconName;
                                   }
                               }];
                           }
                           onFailure:^(NSMutableDictionary *errorDict) {
                               [BZRValidator cleanValidationErrorDict];
                           }];
}

/**
 *  Sign in with facebook
 */
- (void)signInWithFacebook
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BZRFacebookService authorizeWithFacebookOnSuccess:^(BOOL isSuccess) {
        
        [BZRFacebookService getFacebookUserProfileOnSuccess:^(BZRFacebookProfile *facebookProfile) {
            
            [BZRProjectFacade signInWithFacebookOnSuccess:^(BOOL isSuccess) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                //detect success login with facebook
                [BZRFacebookService setLoginSuccess:YES];
                
                //go to dashboard
                [weakSelf performSegueWithIdentifier:kDashboardSegueIdentifier sender:weakSelf];
                
            } onFailure:^(NSError *error, BOOL isCanceled, BOOL userExists) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                //Check whether the user has not already signed up
                if (!userExists) {
                    BZRGetStartedController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRGetStartedController class])];
                    controller.redirectedFromFacebookSignInFlow = YES;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
            
        } onFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

/**
 *  Customize text fields and hide incorrect email view, if it has not hidden yet
 */
- (void)customizeFields
{
    [super customizeFields];
    if (!self.incorrectEmailView.isHidden) {
        self.incorrectEmailView.hidden = YES;
    }
}

#pragma mark - Private methods

/**
 *  Get user data from keychain, if needed
 */
- (void)getUserDataFromKeychain
{
    if (self.isRememberMe) {
        NSDictionary *userCredentials = [BZRKeychainHandler getStoredCredentials];
        self.userNameField.text = userCredentials[UserNameKey];
        self.passwordField.text = userCredentials[PasswordKey];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kDashboardSegueIdentifier]) {
        BZRDashboardController *controller = (BZRDashboardController *)segue.destinationViewController;
        controller.updateNeeded = YES;
    }
}

@end
