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

#import "BZRProjectFacade.h"

#import "BZRLocationEvent.h"

#import "BZRAlertFacade.h"

static NSString *const kGeolocationPermissionsLastState = @"geolocationPermissionsLastState";

static NSString *const kOBStore = @"Store";

@interface BZRLocationObserver ()<CLLocationManagerDelegate, OB_LocationServicesDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

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
        
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            // iOS8+
            // Sending a message to avoid compile time error
            [[UIApplication sharedApplication] sendAction:@selector(requestAlwaysAuthorization)
                                                       to:_locationManager
                                                     from:self
                                                 forEvent:nil];
        }
        
        [_locationManager startUpdatingLocation];
        [self setupOfferBeamObserver];
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
    BOOL isGeolocationEnable = NO;
    BOOL isGeolocationStatusDetermine = YES;
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        isGeolocationEnable = YES;
    } else if (status == kCLAuthorizationStatusDenied) {
        isGeolocationEnable = NO;
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        isGeolocationStatusDetermine = NO;
    }
    
    if (isGeolocationStatusDetermine) {
       [self checkForPermissionsChangingWithGeolocationEnabled:isGeolocationEnable];
        
        if (isGeolocationEnable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidSuccessAuthorizeNotification object:nil];
        } else {
//            [BZRAlertFacade showGlobalGeolocationPermissionsAlertWithCompletion:^(UIAlertAction *action) {
//                if (action.style != UIAlertActionStyleCancel) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                } else {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidFailAuthorizeNotification object:nil];
//                }
//            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidFailAuthorizeNotification object:nil];
        }
    }
}

#pragma mark - Public methods

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Private methods

/**
 *  Check for changing permissions for geolocation access and track this event
 *
 *  @param isGeolocationEnable Enable value
 */
- (void)checkForPermissionsChangingWithGeolocationEnabled:(BOOL)isGeolocationEnable
{
    BOOL permissionsLastState = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:kGeolocationPermissionsLastState]) {
        permissionsLastState = isGeolocationEnable;
        [defaults setBool:permissionsLastState forKey:kGeolocationPermissionsLastState];
    } else {
        permissionsLastState = [defaults boolForKey:kGeolocationPermissionsLastState];
    }
    
    BOOL isPermissionsChanged = permissionsLastState == isGeolocationEnable ? NO : YES;
    
    if (isPermissionsChanged) {
        [defaults setBool:isGeolocationEnable forKey:kGeolocationPermissionsLastState];
        
        [BZRMixpanelService trackEventWithType:BZRMixpanelEventLocationPermission propertyValue:isGeolocationEnable? AccessGrantedKeyYes : AccessGrantedKeyNo];
    }
}

#pragma mark - Private methods

- (void)setupOfferBeamObserver
{
    [[OB_Services sharedInstance] requestAlwaysAuthorization];
    [OB_Services setLocationDelegate:self];
}

- (void)sendLocationEventWithInitDictionary:(NSDictionary *)dictionary andType:(BZRLocaionEventType)eventType
{
    if ([BZRProjectFacade isUserSessionValid]) {
        BZRLocationEvent *locationEvent = [[BZRLocationEvent alloc] initWithServerResponse:dictionary[kOBStore]];
        locationEvent.eventType = eventType;
        
        [BZRProjectFacade sendGeolocationEvent:locationEvent onSuccess:^(BZRLocationEvent *locationEvent) {
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            
        }];
    }
}

#pragma mark - OB_LocationServicesDelegate

- (void)OB_receivedOnEnter:(NSDictionary *)data
{
    [self sendLocationEventWithInitDictionary:data andType:BZRLocaionEventTypeEntry];
}

- (void)OB_receivedOnExit:(NSDictionary *)data
{
    [self sendLocationEventWithInitDictionary:data andType:BZRLocaionEventTypeExit];
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
