//
//  BZRPushNotificationsAccessController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
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
    [BZRPushNotifiactionService registerApplicationForPushNotifications:[UIApplication sharedApplication]];
}

- (IBAction)skipThisStepClick:(id)sender
{
    [self performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:self];
}

#pragma mark - Notifications

/**
 *  Registering for push notification access notifications
 */
- (void)handlePushNotificationsAccessNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationServiceDidSuccessAuthorizeNotification:) name:PushNotificationServiceDidSuccessAuthorizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationServiceDidFailAuthorizeNotification:) name:PushNotificationServiceDidFailAuthorizeNotification object:nil];
}

/**
 *  Handle success authorization
 *
 *  @param notification PushNotificationServiceDidSuccessAuthorizeNotification
 */
- (void)pushNotificationServiceDidSuccessAuthorizeNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:self];
}

/**
 *  Handle failure authorization
 *
 *  @param notification PushNotificationServiceDidFailAuthorizeNotification
 */
- (void)pushNotificationServiceDidFailAuthorizeNotification:(NSNotification *)notification
{
    NSError *error = notification.object;
    [self showAlertControllerWithError:error];
}

#pragma mark - UIAlertController

- (void)showAlertControllerWithError:(NSError *)error
{
    WEAK_SELF;
    [BZRAlertFacade showGlobalPushNotificationsPermissionsAlertForController:self withCompletion:^(UIAlertAction *action, BOOL isCanceled) {
        if (isCanceled) {
            [weakSelf performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:weakSelf];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
}

/**
 *  Set default status bar style because the background is white
 *
 *  @return UIStatusBarStyleDefault
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
