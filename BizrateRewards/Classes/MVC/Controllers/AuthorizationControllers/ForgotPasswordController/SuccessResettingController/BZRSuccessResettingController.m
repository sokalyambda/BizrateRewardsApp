//
//  BZRSuccessResettingController.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSuccessResettingController.h"

#import "BZRDashboardController.h"

#import "BZRProjectFacade.h"

#import "BZRKeychainHandler.h"

@interface BZRSuccessResettingController ()

@end

@implementation BZRSuccessResettingController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self updateKeychainItem];
}

#pragma mark - Actions

- (IBAction)continueClick:(id)sender
{
    WEAK_SELF;
    [BZRProjectFacade signOutOnSuccess:^(BOOL isSuccess) {
        [[BZRStorageManager sharedStorage] swapTokens];
        BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
        
        //Swap temporary credentials with user credentials
        NSDictionary *credentials = [BZRKeychainHandler getStoredCredentialsForService:TemporaryCredentialsKey];
        NSString *userName = credentials[UserNameKey];
        NSString *password = credentials[PasswordKey];
        [BZRKeychainHandler storeCredentialsWithUsername:userName andPassword:password forService:UserCredentialsKey];
        
        controller.updateNeeded = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
    }];
}

- (IBAction)closeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  After password resetting we shoud to check whether stored userName is equal to temporary user name. If it's true - reset keychain user credentials
 */
- (void)updateKeychainItem
{
    NSDictionary *storedCredentials = [BZRKeychainHandler getStoredCredentialsForService:UserCredentialsKey];
    NSDictionary *temporaryCredentials = [BZRKeychainHandler getStoredCredentialsForService:TemporaryCredentialsKey];
    
    NSString *storedUserName = storedCredentials[UserNameKey];
    NSString *temporaryUserName = temporaryCredentials[UserNameKey];
    
    if ([storedUserName isEqualToString:temporaryUserName]) {
        [BZRKeychainHandler resetKeychainForService:UserCredentialsKey];
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
