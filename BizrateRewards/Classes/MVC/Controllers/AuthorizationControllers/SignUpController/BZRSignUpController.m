//
//  BZRSignUpController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignUpController.h"

#import "BZRDataManager.h"

#import "BZRLeftImageTextField.h"

@interface BZRSignUpController ()

@property (weak, nonatomic) IBOutlet BZRLeftImageTextField *userNameField;
@property (weak, nonatomic) IBOutlet BZRLeftImageTextField *passwordField;

@property (strong, nonatomic) BZRDataManager *dataManager;

@end

@implementation BZRSignUpController

#pragma mark - Accessors

- (BZRDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [BZRDataManager sharedInstance];
    }
    return _dataManager;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeFields];
}

#pragma mark - Actions

- (IBAction)createAccountClick:(id)sender
{
    WEAK_SELF;
    [self.dataManager getClientCredentialsOnSuccess:^(BOOL success, NSError *error) {
        if (success) {
            [weakSelf.dataManager signUpWithUserFirstName:nil andUserLastName:nil andEmail:nil withResult:^(BOOL success, NSError *error) {
                if (!success) {
                    ShowErrorAlert(error);
                }
            }];
        }
    }];
}

- (void)customizeFields
{
    self.userNameField.imageName = @"email_icon";
    self.passwordField.imageName = @"password_icon";
}


@end
