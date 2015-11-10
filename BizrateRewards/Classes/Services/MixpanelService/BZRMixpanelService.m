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

static Mixpanel *_currentMixpanelProject = nil;
static NSArray *_possibleMixPanels = nil;

@implementation BZRMixpanelService

#pragma mark - Accessors

+ (NSArray *)possibleMixPanels
{
    if (!_possibleMixPanels) {
        _possibleMixPanels = @[
                               [[Mixpanel alloc] initWithToken:@"a41e6ca3f37c963b273649b0436e5de5" andFlushInterval:1],
                               [[Mixpanel alloc] initWithToken:@"bf2a5a29d476a3f626ff7c1fa35d4e3e" andFlushInterval:1],
                               [[Mixpanel alloc] initWithToken:@"aae3e2388125817b27b8afcf99093d97" andFlushInterval:1]];
    }
    return _possibleMixPanels;
}

+ (Mixpanel *)currentMixpanelProject
{
    @synchronized(self) {
        if (!_currentMixpanelProject) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"apiToken == %@", [self mixpanelToken]];
            _currentMixpanelProject = [[self possibleMixPanels] filteredArrayUsingPredicate:predicate].count ? [[self possibleMixPanels] filteredArrayUsingPredicate:predicate].firstObject : nil;
        }
        return _currentMixpanelProject;
    }
}

+ (void)removeCurrentMixpanelProject
{
    @synchronized(self) {
        _currentMixpanelProject = nil;
    }
}

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
    [self removeCurrentMixpanelProject];
}

+ (void)trackEventWithType:(BZRMixpanelEventType)eventType propertyValue:(NSString *)propertyValue
{
    Mixpanel *mixpanel = [self currentMixpanelProject];
    
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
    Mixpanel *mixpanel = [self currentMixpanelProject];
    
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
    Mixpanel *mixpanel = [self currentMixpanelProject];
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
