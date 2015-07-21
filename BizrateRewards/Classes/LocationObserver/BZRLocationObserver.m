//
//  BZRLocationObserver.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRLocationObserver.h"

#import <CoreLocation/CoreLocation.h>

#import "OB_Services.h"

@interface BZRLocationObserver ()<CLLocationManagerDelegate, OB_LocationServicesDelegate>

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
        [_locationManager startUpdatingLocation];
        
//        [self authorizeOfferBeamObserver];
        
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
//    [[OB_LocationServices sharedInstance].locationManager startUpdatingLocation];
}

#pragma mark - Private methods

- (void)authorizeOfferBeamObserver
{
    [[OB_Services sharedInstance] requestAlwaysAuthorization];
    [OB_Services setLocationDelegate:self];
}

#pragma mark - OB_LocationServicesDelegate

- (void)OB_receivedOnEnter:(NSDictionary *)data
{
    NSLog(@"received on enter %@", data);
}

- (void)OB_receivedOnExit:(NSDictionary *)data
{
    NSLog(@"received on exit %@", data);
}

- (void)send_message:(NSString *)str
{
    
}

- (void)OB_receivedOnBKEnter:(NSString *)beacon
{
    
}

-(void)OB_didEnterRegion:(CLRegion *)region
{
    
}

- (void)OB_didExitRegion:(CLRegion *)region
{
    
}

@end
