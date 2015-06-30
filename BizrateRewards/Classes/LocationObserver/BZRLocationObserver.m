//
//  BZRLocationObserver.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRLocationObserver.h"

#import <CoreLocation/CoreLocation.h>

@interface BZRLocationObserver ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *updatedLocation;

@end

@implementation BZRLocationObserver

#pragma mark - Accessors

- (BOOL)isAuthorized
{
    return [CLLocationManager authorizationStatus] == (kCLAuthorizationStatusAuthorizedAlways);
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate           = self;
        _locationManager.distanceFilter     = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy    = kCLLocationAccuracyKilometer;
        
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) { // iOS8+
            // Sending a message to avoid compile time error
            [[UIApplication sharedApplication] sendAction:@selector(requestAlwaysAuthorization)
                                                       to:_locationManager
                                                     from:self
                                                 forEvent:nil];
        }
        
        _updatedLocation = nil;
//        [_locationManager startUpdatingLocation];
        
    }
    return self;
}

+ (BZRLocationObserver*)sharedObserver
{
    static BZRLocationObserver *locationObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationObserver = [[BZRLocationObserver alloc] init];
    });
    
    return locationObserver;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidSuccessAuthorizeNotification object:nil];
    }
    
    if (status == kCLAuthorizationStatusDenied) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidFailAuthorizeNotification object:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.updatedLocation = manager.location;
    //[self.locationManager stopUpdatingLocation];
}

#pragma mark - Public methods

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

@end
