//
//  BZRSettingsContaiterController.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef enum : NSUInteger {
    BZRAccessTypeGeolocation,
    BZRAccessTypePushNotifications
} BZRAccessType;

typedef enum : NSUInteger {
    BZRSettingsCellPersonalInfo,
    BZRSettingsCellGeoLocation,
    BZRSettingsCellPushNotification,
    BZRSettingsCellTermsOfService,
    BZRSettingsCellUserAgreement,
    BZRSettingsCellPrivacyPolicy,
    BZRSettingsCellContactSupport
} BZRSettingsCellType;

#import "BZRAccountSettingsContaiterController.h"

#import "BZRPushNotifiactionService.h"
#import "BZRLocationObserver.h"
#import "BZRTermsAndConditionsHelper.h"

static NSString *const kEditProfileSegueIdentifier = @"editProfileSegue";

@interface BZRAccountSettingsContaiterController ()

@property (weak, nonatomic) IBOutlet UIImageView *geolocationAccessIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pushNotificationsAccessIcon;

@end

@implementation BZRAccountSettingsContaiterController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self handleNotifications];
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
            [self showErrorAlertControllerWithAccessType:BZRAccessTypeGeolocation];
            break;
        }
            
        case BZRSettingsCellPushNotification: {
            [self showErrorAlertControllerWithAccessType:BZRAccessTypePushNotifications];
            break;
        }
            
        case BZRSettingsCellTermsOfService: {
            [BZRTermsAndConditionsHelper showPrivacyAndTermsWithType:BZRConditionsTypeTermsAndConditions andWithNavigationController:self.navigationController];
            break;
        }
            
        case BZRSettingsCellUserAgreement: {
            [BZRTermsAndConditionsHelper showPrivacyAndTermsWithType:BZRConditionsTypeUserAgreement andWithNavigationController:self.navigationController];
            break;
        }
            
        case BZRSettingsCellPrivacyPolicy: {
            [BZRTermsAndConditionsHelper showPrivacyAndTermsWithType:BZRConditionsTypePrivacyPolicy andWithNavigationController:self.navigationController];
            break;
        }
            
        case BZRSettingsCellContactSupport: {
            break;
        }
            
    }
}

#pragma mark - Actions

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

#pragma mark - UIAlertController

- (void)showErrorAlertControllerWithAccessType:(BZRAccessType)accessType
{
    NSString *alertMessage;
    switch (accessType) {
        case BZRAccessTypeGeolocation:
            alertMessage = NSLocalizedString(@"Do you want to enable/disable geolocation from settings?", nil);
            break;
        case BZRAccessTypePushNotifications:
            alertMessage = NSLocalizedString(@"Do you want to enable/disable push notifications from settings?", nil);
            break;
        default:
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Notifications

- (void)handleNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:ApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self updateAccessIcons];
}

@end
