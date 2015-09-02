//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"
#import <Mixpanel.h>

#import "BZRLocationEvent.h"

#import "BZRPushNotifiactionService.h"
#import "BZRLocationObserver.h"

static NSString *const kMixpanelToken = @"aae3e2388125817b27b8afcf99093d97";

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
NSString *const kBizrateIDProperty        = @"Bizrate ID";

@implementation BZRMixpanelService

+ (void)setupMixpanel
{
    [Mixpanel sharedInstanceWithToken:kMixpanelToken];
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
    
    BOOL isPushesEnabled = [BZRPushNotifiactionService pushNotificationsEnabled];
    BOOL isGeolocationEnabled = [BZRLocationObserver sharedObserver].isAuthorized;
    
    [mixpanel.people set:@{kPushNotificationsEnabled:isPushesEnabled? @"YES" : @"NO",
                           kGeoLocationEnabled:isGeolocationEnabled? @"YES" : @"NO",
                           kFirstNameProperty:userProfile.firstName,
                           kLastNameProperty:userProfile.lastName,
                           kBizrateIDProperty:userProfile.contactID}];
}

+ (void)setAliasForUser:(BZRUserProfile *)userProfile
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kMixpanelAliasID] isEqualToString:userProfile.contactID]) {
        [mixpanel createAlias:userProfile.contactID forDistinctID:mixpanel.distinctId];
        [mixpanel identify:mixpanel.distinctId];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userProfile.contactID forKey:kMixpanelAliasID];
        [defaults synchronize];
    }
}

@end
