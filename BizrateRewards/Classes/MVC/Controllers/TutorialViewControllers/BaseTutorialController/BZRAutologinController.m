//
//  BZRTutorialViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAutologinController.h"
#import "BZRStartTutorialController.h"
#import "BZRFinishTutorialController.h"
#import "BZRDashboardController.h"
#import "BZRBaseNavigationController.h"
#import "BZRForgotPasswordController.h"

#import "BZRProjectFacade.h"

#import "BZRKeychainHandler.h"

static NSString *const kStartTutorialSegueIdentirier = @"startTutorialSegue";

@interface BZRAutologinController ()

@property (assign, nonatomic, getter=isTutorialPassed) BOOL tutorialPassed;
@property (assign, nonatomic, getter=isFacebookSessionValid) BOOL facebookSessionValid;

@property (assign, nonatomic, getter=isForgotPasswordRedirectionNeeded) BOOL forgotPasswordRedirecionNeeded;
@property (assign, nonatomic, getter=isAppOpenedWithURL) BOOL appOpenedWithURL;

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) NSString *savedPassword;
@property (strong, nonatomic) NSString *savedUsername;

@end

@implementation BZRAutologinController

#pragma mark - Accessors

- (BOOL)isTutorialPassed
{
    return [self.defaults boolForKey:IsTutorialPassed];
}

- (BOOL)isFacebookSessionValid
{
    _facebookSessionValid = [BZRProjectFacade isFacebookSessionValid];
    if (_facebookSessionValid) {
        return !self.isAppOpenedWithURL;
    }
    return NO;
}

- (BOOL)isForgotPasswordRedirecionNeeded
{
    return [BZRStorageManager sharedStorage].resettingPasswordRepeatNeeded;
}

- (BOOL)isAppOpenedWithURL
{
    return [BZRStorageManager sharedStorage].appOpenedWithURL;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForRedirection];
}

#pragma mark - Actions

/**
 *  Check where we have to redirect the user, depends on previous sessions parameters.
 */
- (void)checkForRedirection
{
    if (self.isForgotPasswordRedirecionNeeded) {
        [self showForgotPasswordController];
    } else if ([self isAutologinNeeded]) {
        [self autologinWithEmail];
    } else if (self.isFacebookSessionValid) {
        [self autologinWithFacebook];
    } else if (self.isTutorialPassed) {
        [self goToFinishTutorialController];
    } else {
        [self performSegueWithIdentifier:kStartTutorialSegueIdentirier sender:self];
    }
}

/**
 *  Checking whether autologin with email needed
 *
 *  @return Returns YES if tutorial has been passed and user had switched 'remember me' to 'true'. Otherwise, returns NO.
 */
- (BOOL)isAutologinNeeded
{
    if (self.isTutorialPassed && [self userDataExistsInKeychain]) {
        return !self.isAppOpenedWithURL;
    }
    return NO;
}

/**
 *  Checking whether user data exists in keychain
 *
 *  @return Returns 'YES' if user's auth data exists in keychain. Otherwise, returns 'NO'.
 */
- (BOOL)userDataExistsInKeychain
{
    NSDictionary *userCredentials = [BZRKeychainHandler getStoredCredentialsForService:UserCredentialsKey];
    self.savedPassword = userCredentials[PasswordKey];
    self.savedUsername = userCredentials[UserNameKey];
    
    return self.savedUsername.length && self.savedPassword.length;
}

/**
 *  Perform autologin with email
 */
- (void)autologinWithEmail
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [BZRProjectFacade signInWithEmail:weakSelf.savedUsername password:weakSelf.savedPassword success:^(BOOL success) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf goToDashboardController];
        
    } failure:^(NSError *error, BOOL isCanceled, BOOL emailRegistered) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [BZRAlertFacade showFailureResponseAlertWithError:error forController:self andCompletion:^{
            [weakSelf goToFinishTutorialController];
        }];
    }];
}

/**
 *  Perform autologin with Facebook
 */
- (void)autologinWithFacebook
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [BZRProjectFacade signInWithFacebookOnSuccess:^(BOOL isSuccess) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf goToDashboardController];
        
    } onFailure:^(NSError *error, BOOL isCanceled, BOOL userExists) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (userExists) {
            [BZRAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:^{
                [weakSelf goToFinishTutorialController];
            }];
        }
    }];
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
 *  Move to dashboard controller
 */
- (void)goToDashboardController
{
    BZRDashboardController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
    controller.updateNeeded = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  Move to finish tutorial controller
 */
- (void)goToFinishTutorialController
{
    BZRFinishTutorialController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRFinishTutorialController class])];
    
    [self.navigationController pushViewController:controller animated:YES];
    
 }

/**
 *  Present forgot password view controller.
 */
- (void)showForgotPasswordController
{
    BZRForgotPasswordController *forgotPasswordController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRForgotPasswordController class])];
    BZRBaseNavigationController *navigationController = [[BZRBaseNavigationController alloc] initWithRootViewController:forgotPasswordController];
    [self presentViewController:navigationController animated:YES completion:nil];
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
