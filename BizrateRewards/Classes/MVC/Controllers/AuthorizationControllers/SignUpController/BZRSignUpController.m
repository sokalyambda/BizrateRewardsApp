//
//  BZRSignUpController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignUpController.h"

#import "BZRDataManager.h"

@interface BZRSignUpController ()

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


@end
