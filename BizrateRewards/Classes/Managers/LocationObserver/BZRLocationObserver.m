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

#import "BZRLocationEvent.h"

#import "BZRAlertFacade.h"
#import "BZRProjectFacade.h"

#import "BZRLocationEventService.h"

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

+ (BZRLocationObserver*)sharedObserver
{
    static BZRLocationObserver *locationObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationObserver = [[BZRLocationObserver alloc] init];
        [locationObserver startUpdatingLocation];
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
            
            //run OB observer
            [self setupOfferBeamObserver];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidSuccessAuthorizeNotification object:nil];
        } else {
            [BZRAlertFacade showGlobalGeolocationPermissionsAlertForController:nil withCompletion:^(UIAlertAction *action, BOOL isCanceled) {
                if (!isCanceled) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidFailAuthorizeNotification object:nil];
                }
            }];
        }
    }
}

#pragma mark - Public methods

- (void)initLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate           = self;
    _locationManager.distanceFilter     = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy    = kCLLocationAccuracyKilometer;

    [_locationManager startUpdatingLocation];
}

- (void)startUpdatingLocation
{
    [self initLocationManager];
    [self setupOfferBeamObserver];
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
        
        //track mixpanel event
        [BZRMixpanelService trackEventWithType:BZRMixpanelEventLocationPermission
                                 propertyValue:isGeolocationEnable? @"YES" : @"NO"];
        
        /*
         Commented because of version 1.0.1
         
        if ([BZRProjectFacade isUserSessionValid] && [BZRStorageManager sharedStorage].deviceToken.length) {
            //update notifications and geolocation settings
            [BZRProjectFacade sendDeviceDataOnSuccess:^(BOOL isSuccess) {
                
                DLog(@"geolocation access have been updated");
                
            } onFailure:^(NSError *error, BOOL isCanceled) {
                
            }];
        }
         */
    }
}

#pragma mark - Private methods

/**
 *  Assign Offer Beam delegate to self
 */
- (void)setupOfferBeamObserver
{
    [OB_Services setLocationDelegate:self];
    [OB_Services startLocationService];
}

/**
 *  Send locaiton event
 *
 *  @param dictionary Dictionary for initializing of location event
 *  @param eventType  Current event type (ETNRY/EXIT)
 */
- (void)sendLocationEventWithInitDictionary:(NSDictionary *)dictionary andType:(BZRLocaionEventType)eventType
{
    if ([BZRProjectFacade isUserSessionValid]) {
        BZRLocationEvent *locationEvent = [BZRLocationEventService locationEventFromOfferBeamResponse:dictionary[kOBStore]];
        
        locationEvent.eventType = eventType;
        //track mixpanel event (enter/exit geofence)
        [BZRMixpanelService trackLocationEvent:locationEvent];
        
        //set last location event to userDefaults
        [BZRLocationEventService setLocationEvent:locationEvent toDefaultsForKey:LastReceivedLocationEvent];
        
        [BZRProjectFacade sendGeolocationEvent:locationEvent onSuccess:^(BZRLocationEvent *locationEvent) {
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            
        }];
    }
}

#pragma mark - OB_LocationServicesDelegate

/**
 *  All methods below should be implemented because OBSDK requires it
 */

- (void)OB_receivedOnEnter:(NSDictionary *)data
{
    [self sendLocationEventWithInitDictionary:data andType:BZRLocationEventTypeEntry];
}

- (void)OB_receivedOnExit:(NSDictionary *)data
{
    [self sendLocationEventWithInitDictionary:data andType:BZRLocationEventTypeExit];
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

- (void)OB_receivedOnerror:(NSDictionary *)error
{
    
}

@end
