//
//  BZRSettingsContaiterController.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRSettingsCellPersonalInfo,
    BZRSettingsCellGeoLocation,
    BZRSettingsCellPushNotification,
    BZRSettingsCellTermsOfService,
    BZRSettingsCellContactSupport,
    BZRSettingsCellDiagnostics
} BZRSettingsCellType;

#import "BZRAccountSettingsContaiterController.h"
#import "BZRDiagnosticsController.h"
#import "BZRBaseNavigationController.h"

#import "BZRPushNotifiactionService.h"
#import "BZRLocationObserver.h"
#import "BZRRedirectionHelper.h"

#import "BZRMailComposeManager.h"

#import "BZRZeroInsetsSeparatorCell.h"

static NSString *const kEditProfileSegueIdentifier = @"editProfileSegue";

static CGFloat const kCellHeight = 41.f;

@interface BZRAccountSettingsContaiterController ()

@property (weak, nonatomic) IBOutlet UIImageView *geolocationAccessIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pushNotificationsAccessIcon;

@property (weak, nonatomic) IBOutlet BZRZeroInsetsSeparatorCell *diagnosticCell;

@property (strong, nonatomic) BZRMailComposeManager *mailManager;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@end

@implementation BZRAccountSettingsContaiterController

#pragma mark - Accessors

- (BZRUserProfile *)currentProfile
{
    _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    return _currentProfile;
}

- (BZRMailComposeManager *)mailManager
{
    if (!_mailManager) {
        _mailManager = [BZRMailComposeManager sharedManager];
    }
    return _mailManager;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForNotifications];
    [self updateAccessIcons];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BZRSettingsCellType cellType = indexPath.row;
    switch (cellType) {
        case BZRSettingsCellPersonalInfo: {
            [self.parentViewController performSegueWithIdentifier:kEditProfileSegueIdentifier sender:self];
            break;
        }
        case BZRSettingsCellGeoLocation: {
            [BZRAlertFacade showChangePermissionsAlertWithAccessType:BZRAccessTypeGeolocation forController:self.parentViewController andCompletion:nil];
            break;
        }
        case BZRSettingsCellPushNotification: {
            [BZRAlertFacade showChangePermissionsAlertWithAccessType:BZRAccessTypePushNotifications forController:self.parentViewController andCompletion:nil];
            break;
        }
        case BZRSettingsCellTermsOfService: {
            [BZRRedirectionHelper showPrivacyAndTermsWithType:BZRConditionsTypeTermsAndConditions andWithPresentingController:self];
            break;
        }
        case BZRSettingsCellContactSupport: {
            [self.mailManager showMailComposeControllerWithPresentingController:self.parentViewController andResult:^(MFMailComposeViewController *mailController, MFMailComposeResult composeResult, NSError *error) {
                [mailController dismissViewControllerAnimated:YES completion:nil];
            }];
            break;
        }
        case BZRSettingsCellDiagnostics: {
            BZRDiagnosticsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDiagnosticsController class])];
            BZRBaseNavigationController *navigationController = [[BZRBaseNavigationController alloc] initWithRootViewController:controller];
            controller.settingsController = (BZRAccountSettingsController *)self.parentViewController;
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isEqual:self.diagnosticCell] && !self.currentProfile.isTestUser) {
        return 0.f;
    }
    return kCellHeight;
}

#pragma mark - Actions

/**
 *  Update icons that depends on permissions access
 */
- (void)updateAccessIcons
{
    NSString *currentLocationImageName;
    NSString *currentPushesImageName;
    
    BOOL isPushesEnabled = [BZRPushNotifiactionService pushNotificationsEnabled];
    BOOL isGeolocationEnabled = [BZRLocationObserver sharedObserver].isAuthorized;
    
    currentLocationImageName = isGeolocationEnabled ? @"checkboxes_selected" : @"error_notification";
    currentPushesImageName = isPushesEnabled ? @"checkboxes_selected" : @"error_notification";
    
    self.pushNotificationsAccessIcon.image = [UIImage imageNamed:currentPushesImageName];
    self.geolocationAccessIcon.image = [UIImage imageNamed:currentLocationImageName];
}

#pragma mark - Notifications

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self updateAccessIcons];
}

@end
