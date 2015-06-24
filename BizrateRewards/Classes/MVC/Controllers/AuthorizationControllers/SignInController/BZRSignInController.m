//
//  BZRSignInController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignInController.h"

#import "BZRDataManager.h"

@interface BZRSignInController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) BZRDataManager *dataManager;

@end

@implementation BZRSignInController

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
    [self.view layoutIfNeeded];
}

#pragma mark - Actions

//facebook
- (IBAction)facebookLoginClick:(id)sender
{

    [self.dataManager signInWithFacebookWithResult:^(BOOL success, NSError *error) {
        
    }];
    
}

//email
- (IBAction)signInClick:(id)sender
{
}

- (IBAction)rememberMeClick:(id)sender
{
}

@end
