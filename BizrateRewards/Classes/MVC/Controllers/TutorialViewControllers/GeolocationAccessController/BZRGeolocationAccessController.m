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

/**
 *  Register location access notifications
 */
- (void)handleLocationObserverNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidSuccessAuthorizeNotification:) name:LocationManagerDidSuccessAuthorizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidFailAuthorizeNotification:) name:LocationManagerDidFailAuthorizeNotification object:nil];
}

/**
 *  Handle success authorization
 *
 *  @param notification LocationManagerDidSuccessAuthorizeNotification
 */
- (void)locationManagerDidSuccessAuthorizeNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:kPushNotificationsAccessSegueIdentifier sender:self];
}

/**
 *  Handle failure authorization
 *
 *  @param notification LocationManagerDidFailAuthorizeNotification
 */
- (void)locationManagerDidFailAuthorizeNotification:(NSNotification *)notification
{
    [self performSegueWithIdentifier:kPushNotificationsAccessSegueIdentifier sender:self];
}

- (IBAction)skipThisStepClick:(id)sender
{
    [self performSegueWithIdentifier:kPushNotificationsAccessSegueIdentifier sender:self];
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
