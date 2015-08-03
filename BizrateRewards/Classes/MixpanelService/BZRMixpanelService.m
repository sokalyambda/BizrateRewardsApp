//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"
#import <Mixpanel.h>

#import "BZRUserProfile.h"

#import "BZRPushNotifiactionService.h"
#import "BZRLocationObserver.h"

static NSString *const kMixpanelToken = @"aae3e2388125817b27b8afcf99093d97";//@"f818411581cc210c670fe3351a46debe";

static NSString *const kMixpanelEventsFile = @"MixpanelEvents";
static NSString *const kPlistResourceType = @"plist";

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

+ (void)setPeopleForUser:(BZRUserProfile *)userProfile
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    BOOL isPushesEnabled = [BZRPushNotifiactionService pushNotificationsEnabled];
    BOOL isGeolocationEnabled = [BZRLocationObserver sharedObserver].isAuthorized;
    
    [mixpanel.people set:@{PushNotificationsEnabled:isPushesEnabled? AccessGrantedKeyYes : AccessGrantedKeyNo,
                           GeoLocationEnabled:isGeolocationEnabled? AccessGrantedKeyYes : AccessGrantedKeyNo,
                           FirstNameProperty:userProfile.firstName,
                           LastNameProperty:userProfile.lastName,
                           BizrateIDProperty:userProfile.contactID}];
}

+ (void)setAliasForUser:(BZRUserProfile *)userProfile
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:MixpanelAliasID] isEqualToString:userProfile.contactID]) {
        [mixpanel createAlias:userProfile.contactID forDistinctID:mixpanel.distinctId];
        [mixpanel identify:mixpanel.distinctId];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userProfile.contactID forKey:MixpanelAliasID];
        [defaults synchronize];
    }
}

@end
