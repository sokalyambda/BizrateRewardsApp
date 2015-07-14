//
//  BZRGeolocationAccessController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGeolocationAccessController.h"

#import "BZRLocationObserver.h"

static NSString *const kPushNotificationsAccessSegueIdentifier = @"pushNotificationsAccessSegue";

@interface BZRGeolocationAccessController ()

@end

@implementation BZRGeolocationAccessController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self handleLocationObserverNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (IBAction)enableGeolocaionClick:(id)sender
{
    [[BZRLocationObserver sharedObserver] startUpdatingLocation];
}

#pragma mark - Notifications

- (void)handleLocationObserverNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidSuccessAuthorizeNotification:) name:LocationManagerDidSuccessAuthorizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidFailAuthorizeNotification:) name:LocationManagerDidFailAuthorizeNotification object:nil];
}

- (void)locationManagerDidSuccessAuthorizeNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:kPushNotificationsAccessSegueIdentifier sender:self];
}

- (void)locationManagerDidFailAuthorizeNotification:(NSNotification *)notification
{
    [self showErrorAlertController];
}

- (IBAction)skipThisStepClick:(id)sender
{
    [self performSegueWithIdentifier:kPushNotificationsAccessSegueIdentifier sender:self];
}

#pragma mark - UIAlertController

- (void)showErrorAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to enable geolocation from settings?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:kPushNotificationsAccessSegueIdentifier sender:self];
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
