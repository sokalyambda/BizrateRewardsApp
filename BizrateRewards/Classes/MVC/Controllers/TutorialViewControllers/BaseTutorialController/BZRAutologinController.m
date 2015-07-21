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

#import "BZRAuthorizationService.h"

#import "BZRKeychainHandler.h"

static NSString *const kStartTutorialSegueIdentirier = @"startTutorialSegue";

@interface BZRAutologinController ()

@property (assign, nonatomic, getter=isTutorialPassed) BOOL tutorialPassed;
@property (assign, nonatomic, getter=isRememberMe) BOOL rememberMe;

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

- (BOOL)isRememberMe
{
    return [self.defaults boolForKey:RememberMeKey];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkForRedirection];
}

#pragma mark - Actions

- (void)checkForRedirection
{
    if ([self isAutologinNeeded]) {
        [self autologin];
    } else if (self.isTutorialPassed) {
        [self goToFinishTutorialController];
    } else {
        [self performSegueWithIdentifier:kStartTutorialSegueIdentirier sender:self];
    }
}

- (BOOL)isAutologinNeeded
{
    if (self.isTutorialPassed && [self userDataExistsInKeychain]) {
        return YES;
    }
    return NO;
}

- (BOOL)userDataExistsInKeychain
{
    if (!self.isRememberMe) {
        return NO;
    } else {
        NSDictionary *userCredentials = [BZRKeychainHandler getStoredCredentials];
        self.savedPassword = userCredentials[PasswordKey];
        self.savedUsername = userCredentials[UserNameKey];
    }
    return self.savedUsername.length && self.savedPassword.length;
}

- (void)autologin
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [BZRAuthorizationService signInWithUserName:weakSelf.savedUsername password:weakSelf.savedPassword onSuccess:^(BZRApplicationToken *token) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf goToDashboardController];
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        ShowFailureResponseAlertWithError(error);
        [weakSelf goToFinishTutorialController];
        
    }];
}

#pragma mark - Navigation

- (void)goToDashboardController
{
    BZRDashboardController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
    controller.updateNeeded = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToFinishTutorialController
{
    BZRFinishTutorialController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRFinishTutorialController class])];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
