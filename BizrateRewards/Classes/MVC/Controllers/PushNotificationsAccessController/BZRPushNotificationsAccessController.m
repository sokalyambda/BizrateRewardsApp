//
//  BZRPushNotificationsAccessController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRPushNotificationsAccessController.h"

#import "BZRPushNotifiactionService.h"

static NSString *const kFinalTutorialControllerSegueIdentifier = @"finalTutorialControllerSegue";

@interface BZRPushNotificationsAccessController ()

@end

@implementation BZRPushNotificationsAccessController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self handlePushNotificationsAccessNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (IBAction)enablePushNotificationsClick:(id)sender
{
    if (![BZRPushNotifiactionService pushNotificationsEnabled]) {
        [BZRPushNotifiactionService registerApplicationForPushNotifications:[UIApplication sharedApplication]];
    } else {
        [self performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:self];
    }
}

- (IBAction)skipThisStepClick:(id)sender
{
    [self performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:self];
}

#pragma mark - Notifications

- (void)handlePushNotificationsAccessNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationServiceDidSuccessAuthorizeNotification:) name:PushNotificationServiceDidSuccessAuthorizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationServiceDidFailAuthorizeNotification:) name:PushNotificationServiceDidFailAuthorizeNotification object:nil];
}

- (void)pushNotificationServiceDidSuccessAuthorizeNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:self];
}

- (void)pushNotificationServiceDidFailAuthorizeNotification:(NSNotification *)notification
{
    NSError *error = notification.object;
    [self showAlertControllerWithError:error];
}

#pragma mark - UIAlertController

- (void)showAlertControllerWithError:(NSError *)error
{
    WEAK_SELF;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to enable push-notifications from settings?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [weakSelf performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:weakSelf];
    }];

    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
