//
//  BZRDashboardController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRLocationObserver.h"
#import "BZRStorageManager.h"

#import "BZRDashboardController.h"

#import "BZRRoundedImageView.h"

@interface BZRDashboardController ()

@property (weak, nonatomic) IBOutlet BZRRoundedImageView *userAvatar;

@property (strong, nonatomic) BZRStorageManager *storageManager;

@end

@implementation BZRDashboardController

#pragma mark - Accessors

- (BZRStorageManager *)storageManager
{
    if (!_storageManager) {
        _storageManager = [BZRStorageManager sharedStorage];
    }
    return _storageManager;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BZRLocationObserver sharedObserver];
    [self updateUserInformation];
}

#pragma mark - Actions

- (void)updateUserInformation
{
    [self.userAvatar sd_setImageWithURL:self.storageManager.currentProfile.avatarURL];
}

@end
