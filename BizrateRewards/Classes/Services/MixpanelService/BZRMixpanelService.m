//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"
#import <Mixpanel.h>
#import "BZRPushNotifiactionService.h"
#import "BZREnvironmentService.h"

#import "BZRLocationEvent.h"
#import "BZREnvironment.h"

#import "BZRLocationObserver.h"

//static NSString *const kMixpanelToken = @"aae3e2388125817b27b8afcf99093d97";//live
static NSString *const kMixpanelToken = @"f818411581cc210c670fe3351a46debe";//test

static NSString *const kMixpanelEventsFile = @"MixpanelEvents";
static NSString *const kPlistResourceType  = @"plist";

// Mixpanel events
NSString *const kMixpanelAliasID          = @"MixpanelAliasID";
NSString *const kAuthTypeEmail            = @"Email";
NSString *const kAuthTypeFacebook         = @"Facebook";
NSString *const kPushNotificationsEnabled = @"Push Notifications Enabled";
NSString *const kGeoLocationEnabled       = @"Geo Location Enabled";
NSString *const kFirstNameProperty        = @"First Name";
NSString *const kLastNameProperty         = @"Last Name";
NSString *const kQualtricsContactId       = @"Qualtrics Contact Id"; //mixpanel changes phase 2, was Bizrate ID
NSString *const kBizrateRewardsUserId     = @"Bizrate Rewards User Id";
NSString *const kIsTestUser               = @"Test User";

NSString *defaultMixpanelToken = @"https://api.bizraterewards.com/v1/";
static NSString *_mixpanelToken;

@implementation BZRMixpanelService

#pragma mark - Accessors

+ (NSString *)mixpanelToken
{
    @synchronized(self) {
        
        BZREnvironment *savedEnvironment = [BZREnvironmentService environmentFromDefaultsForKey:CurrentAPIEnvironment];
        
        if (!savedEnvironment) {
            savedEnvironment = [BZREnvironmentService defaultEnvironment];
            [BZREnvironmentService setEnvironment:savedEnvironment toDefaultsForKey:CurrentAPIEnvironment];
        }
        
        if (!_mixpanelToken && savedEnvironment) {
            _mixpanelToken = savedEnvironment.mixPanelToken;
        }
        return _mixpanelToken;
    }
}

+ (void)setMixpanelToken:(NSString *)token
{
    @synchronized(self) {
        _mixpanelToken = token;
    }
}

+ (void)setupMixpanel
{
    [Mixpanel sharedInstanceWithToken:[self mixpanelToken]];
}

/**
 *  Set new MixPanel token
 */
+ (void)reinitMixpanelToken
{
    [[Mixpanel sharedInstance] reinitTokenWithToken:[self mixpanelToken]];
}

+ (void)trackEventWithType:(BZRMixpanelEventType)eventType propertyValue:(NSString *)propertyValue
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSArray *eventsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMixpanelEventsFile ofType:kPlistResourceType]];
    NSString *eventName = [eventsArray[eventType] allKeys].firstObject;
    NSString *propertyKey = eventsArray[eventType][eventName];
    
    if (propertyValue) {
        [mixpanel track:eventName properties:@{propertyKey : propertyValue}];
    } else {
        [mixpanel track:eventName];
    }
}

+ (void)trackLocationEvent:(BZRLocationEvent *)locationEvent
{
    switch (locationEvent.eventType) {
        case BZRLocationEventTypeEntry: {
            [self trackEventWithType:BZRMixpanelEventGeofenceEnter
                       propertyValue:[NSString stringWithFormat:@"%ld",(long)locationEvent.locationId]];
            break;
        }
        case BZRLocationEventTypeExit: {
            [self trackEventWithType:BZRMixpanelEventGeofenceExit
                       propertyValue:[NSString stringWithFormat:@"%ld",(long)locationEvent.locationId]];
            break;
        }
    }
}

+ (void)setPeopleForUser:(BZRUserProfile *)userProfile
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
//    NSString *userIdString = [NSString stringWithFormat:@"%lld", userProfile.userId];
    
   [BZRPushNotifiactionService pushNotificationsEnabledWithCompletion:^(BOOL enabled, BOOL isPermissionsStateChanged) {
        BOOL isGeolocationEnabled = [BZRLocationObserver sharedObserver].isAuthorized;
       
       [mixpanel identify:mixpanel.distinctId];
       
        [mixpanel.people set:@{kPushNotificationsEnabled:enabled? @"YES" : @"NO",
                               kGeoLocationEnabled:isGeolocationEnabled? @"YES" : @"NO",
                               kFirstNameProperty:userProfile.firstName,
                               kLastNameProperty:userProfile.lastName,
                               kQualtricsContactId:userProfile.contactID,
                               kBizrateRewardsUserId:@(userProfile.userId),
                               kIsTestUser:@(userProfile.isTestUser)}];
    }];
    
}

+ (void)setAliasForUser:(BZRUserProfile *)userProfile
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *userIdString = [NSString stringWithFormat:@"%lld", userProfile.userId];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kMixpanelAliasID] isEqualToString:userIdString]) {
        [mixpanel createAlias:userIdString forDistinctID:mixpanel.distinctId];
        [mixpanel identify:userIdString];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userIdString forKey:kMixpanelAliasID];
        [defaults synchronize];
    }
}

@end
