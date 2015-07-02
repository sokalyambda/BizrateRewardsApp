//
//  BZRDashboardController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRStorageManager.h"
#import "BZRDataManager.h"

#import "BZRDashboardController.h"

#import "BZRRoundedImageView.h"
#import "BZRProgressView.h"

static NSString *const kAccountSettingsSegueIdentifier = @"accountSettingsSegueIdentifier";

@interface BZRDashboardController ()

@property (weak, nonatomic) IBOutlet BZRRoundedImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) BZRStorageManager *storageManager;
@property (strong, nonatomic) BZRDataManager *dataManager;

@property (strong, nonatomic) BZRUserProfile *currentProfile;
@property (weak, nonatomic) IBOutlet BZRProgressView *progressView;

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

- (BZRDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [BZRDataManager sharedInstance];
    }
    return _dataManager;
}

- (BZRUserProfile *)currentProfile
{
    if (!_currentProfile) {
        _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    }
    return _currentProfile;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getCurrentUserProfile];
}

#pragma mark - Actions

- (IBAction)accountSettingsClick:(id)sender
{
    [self performSegueWithIdentifier:kAccountSettingsSegueIdentifier sender:self];
}

- (void)updateUserInformation
{
    [self.userAvatar sd_setImageWithURL:self.currentProfile.avatarURL placeholderImage:[UIImage imageNamed:@"user_icon_small"]];
    self.userNameLabel.text = self.currentProfile.fullName;
#warning User Points
    self.currentProfile.pointsAmount = 800;
    self.currentProfile.pointsRequired = 2000;

}

- (void)getCurrentUserProfile
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.dataManager getCurrentUserWithCompletion:^(BOOL success, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (success) {
            [weakSelf updateUserInformation];
            [weakSelf calculateProgress];
        }
    }];
    
}

- (void)calculateProgress
{
     self.progressView.progress  = (CGFloat)self.currentProfile.pointsAmount * CGRectGetWidth(self.progressView.frame) / (CGFloat)self.currentProfile.pointsRequired;
    [self.progressView setNeedsDisplay];
    
}

@end
