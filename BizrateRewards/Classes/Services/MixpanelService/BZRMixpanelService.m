//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"
#import "BZRPushNotifiactionService.h"
#import "BZREnvironmentService.h"

#import "BZRLocationEvent.h"
#import "BZREnvironment.h"

#import "BZRLocationObserver.h"

#import "BZRCoreDataStorage.h"

static NSString *const kMixpanelEventsFile = @"MixpanelEvents";
static NSString *const kPlistResourceType  = @"plist";

// Mixpanel events
NSString *const kAuthTypeEmail            = @"Email";
NSString *const kAuthTypeFacebook         = @"Facebook";
NSString *const kPushNotificationsEnabled = @"Push Notifications Enabled";
NSString *const kGeoLocationEnabled       = @"Geo Location Enabled";
NSString *const kFirstNameProperty        = @"First Name";
NSString *const kLastNameProperty         = @"Last Name";
NSString *const kQualtricsContactId       = @"Qualtrics Contact Id"; //mixpanel changes phase 2, was Bizrate ID
NSString *const kBizrateRewardsUserId     = @"Bizrate Rewards User Id";
NSString *const kIsTestUser               = @"Test User";

static Mixpanel *_currentMixpanelInstance = nil;

@implementation BZRMixpanelService

#pragma mark - Accessors

+ (Mixpanel *)currentMixpanelInstance
{
    @synchronized(self) {
        
        BZREnvironment *savedEnvironment = [self savedEnvironment];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"apiToken == %@", savedEnvironment.mixPanelToken];
        _currentMixpanelInstance = [[BZREnvironmentService possibleMixPanels] filteredArrayUsingPredicate:predicate].count ? [[BZREnvironmentService possibleMixPanels] filteredArrayUsingPredicate:predicate].firstObject : nil;
        
        return _currentMixpanelInstance;
    }
}

+ (BZREnvironment *)savedEnvironment
{
    BZREnvironment *savedEnvironment = [BZRCoreDataStorage getCurrentEnvironment];
    if (!savedEnvironment) {
        savedEnvironment = [BZREnvironmentService defaultEnvironment];
        savedEnvironment.isCurrent = @(YES);
        [BZRCoreDataStorage saveContext];
    }
    return savedEnvironment;
}

+ (void)clearCurrentMixpanelInstance
{
    @synchronized(self) {
        [_currentMixpanelInstance reset];
        _currentMixpanelInstance = nil;
    }
}

+ (void)resetMixpanel
{
    [self clearCurrentMixpanelInstance];
}

+ (void)trackEventWithType:(BZRMixpanelEventType)eventType propertyValue:(NSString *)propertyValue
{
    Mixpanel *mixpanel = [self currentMixpanelInstance];
    
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
    Mixpanel *mixpanel = [self currentMixpanelInstance];
    
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
    Mixpanel *mixpanel = [self currentMixpanelInstance];
    NSString *userIdString = [NSString stringWithFormat:@"%lld", userProfile.userId];

    BZREnvironment *savedEnvironment = [self savedEnvironment];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:savedEnvironment.mixPanelToken] isEqualToString:userIdString]) {
        [mixpanel createAlias:userIdString forDistinctID:mixpanel.distinctId];
        [mixpanel identify:userIdString];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userIdString forKey:savedEnvironment.mixPanelToken];
        [defaults synchronize];
    }
}

+ (void)addPushDeviceToken:(NSData *)deviceToken
{
    Mixpanel *mixpanel = [self currentMixpanelInstance];
    [mixpanel identify:mixpanel.distinctId];
    [mixpanel.people addPushDeviceToken:deviceToken];
}

@end
