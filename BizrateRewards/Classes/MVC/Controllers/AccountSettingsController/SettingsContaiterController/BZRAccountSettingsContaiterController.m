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
    BZRSettingsCellDiagnostics,
    BZRSettingsCellDeleteSurveys
} BZRSettingsCellType;

#import "BZRAccountSettingsContaiterController.h"
#import "BZRDiagnosticsController.h"
#import "BZRBaseNavigationController.h"
#import "BZRAccountSettingsController.h"

#import "BZRPushNotifiactionService.h"
#import "BZRLocationObserver.h"
#import "BZRRedirectionHelper.h"

#import "BZRMailComposeManager.h"

#import "BZRZeroInsetsSeparatorCell.h"

#import "BZRProjectFacade.h"

static NSString *const kEditProfileSegueIdentifier = @"editProfileSegue";

static CGFloat const kCellHeight = 41.f;
static CGFloat const kMinBottomSpace = 8.f;

@interface BZRAccountSettingsContaiterController ()

@property (weak, nonatomic) IBOutlet UIImageView *geolocationAccessIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pushNotificationsAccessIcon;

@property (weak, nonatomic) IBOutlet BZRZeroInsetsSeparatorCell *diagnosticCell;
@property (weak, nonatomic) IBOutlet BZRZeroInsetsSeparatorCell *deleteSurveysCell;

@property (strong, nonatomic) BZRMailComposeManager *mailManager;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@property (weak, nonatomic) BZRAccountSettingsController *parentController;

@end

@implementation BZRAccountSettingsContaiterController

#pragma mark - Accessors

- (BZRAccountSettingsController *)parentController
{
    if ([self.parentViewController isKindOfClass:[BZRAccountSettingsController class]]) {
        _parentController = (BZRAccountSettingsController *)self.parentViewController;
    }
    return _parentController;
}

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForTableScrolling];
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
        case BZRSettingsCellDeleteSurveys: {
            
            [self showDeleteSurveysActionSheet];
            
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (([cell isEqual:self.diagnosticCell] || [cell isEqual:self.deleteSurveysCell]) && !self.currentProfile.isTestUser) {
        return 0.f;
    }
    return kCellHeight;
}

#pragma mark - Actions

/**
 *  Check whether the table view should scroll
 */
- (void)checkForTableScrolling
{
    if (!self.currentProfile.isTestUser) {
        return;
    }
    
    CGFloat parentViewHeight = CGRectGetHeight(self.parentController.view.frame);
    CGFloat spaceForSignOutButton = CGRectGetHeight(self.parentController.signOutButton.frame) + self.parentController.spaceBetweenContainerBottomAndSignOutButtonTop.constant + kMinBottomSpace;
    CGFloat freeHeight = parentViewHeight  - self.parentController.headerHeightConstraint.constant - spaceForSignOutButton;
    
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
    CGFloat heightForRow = self.tableView.rowHeight;
    
    CGFloat actualHeight = self.parentController.containerHeightConstraint.constant;
    CGFloat expectedHeight = numberOfRows * heightForRow;

    if (freeHeight >= expectedHeight && expectedHeight >= actualHeight) {
        WEAK_SELF;
        [self.parentController.view layoutIfNeeded];
        self.parentController.containerHeightConstraint.constant = expectedHeight;
        [UIView animateWithDuration:.1f animations:^{
            [weakSelf.parentController.view layoutIfNeeded];
        }];
    } else if (freeHeight < expectedHeight) {
        self.tableView.scrollEnabled = expectedHeight > actualHeight;
    }
}

/**
 *  Update icons that depends on permissions access
 */
- (void)updateAccessIcons
{
    NSString *currentLocationImageName;
    NSString *currentPushesImageName;
    
    BOOL isPushesEnabled = [BZRPushNotifiactionService isPushNotificationsEnabled];
    BOOL isGeolocationEnabled = [BZRLocationObserver sharedObserver].isAuthorized;
    
    currentLocationImageName = isGeolocationEnabled ? @"checkboxes_selected" : @"error_notification";
    currentPushesImageName = isPushesEnabled ? @"checkboxes_selected" : @"error_notification";
    
    self.pushNotificationsAccessIcon.image = [UIImage imageNamed:currentPushesImageName];
    self.geolocationAccessIcon.image = [UIImage imageNamed:currentLocationImageName];
}

/**
 *  Show delete surveys action sheet
 */
- (void)showDeleteSurveysActionSheet
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to delete already taken surveys?") preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteEligibleSurveys];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self.parentController presentViewController:alertController animated:YES completion:nil];
}

/**
 *  Delete already taken surveys
 */
- (void)deleteEligibleSurveys
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.parentController.view animated:YES];
    [BZRProjectFacade deleteTakenSurveysOnSuccess:^(BOOL isSuccess) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentController.view animated:YES];
        [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"Surveys have been deleted.") forController:weakSelf.parentController withCompletion:nil];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.parentController.view animated:YES];
        [BZRAlertFacade showFailureResponseAlertWithError:error forController:weakSelf.parentController andCompletion:nil];
    }];
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
