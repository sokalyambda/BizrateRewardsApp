//
//  BZRSettingsContaiterController.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRAccountSettingsContaiterController.h"

typedef enum : NSUInteger {
    BZRSettingsCellPersonalInfo,
    BZRSettingsCellGeoLocation,
    BZRSettingsCellPushNotification,
    BZRSettingsCellTermsOfService,
    BZRSettingsCellUserAgreement,
    BZRSettingsCellPrivacyPolicy,
    BZRSettingsCellContactSupport
} BZRSettingsCellType;

static NSString *const kEditProfileSegueIdentifier = @"editProfileSegue";

@interface BZRAccountSettingsContaiterController ()

@end

@implementation BZRAccountSettingsContaiterController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZRSettingsCellType cellType = indexPath.row;
    switch (cellType) {
        case BZRSettingsCellPersonalInfo:
            [self.parentViewController performSegueWithIdentifier:kEditProfileSegueIdentifier sender:self];
            break;
        case BZRSettingsCellGeoLocation:
            break;
        case BZRSettingsCellPushNotification:
            
            break;
        case BZRSettingsCellTermsOfService:
            
            break;
        case BZRSettingsCellUserAgreement:
            
            break;
        case BZRSettingsCellPrivacyPolicy:
            
            break;
        case BZRSettingsCellContactSupport:
            
            break;
    }
}

@end
