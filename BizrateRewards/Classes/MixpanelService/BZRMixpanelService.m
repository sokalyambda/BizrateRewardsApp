//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"

#import <Mixpanel.h>

static NSString *const kMixpanelToken = @"aae3e2388125817b27b8afcf99093d97";

@implementation BZRMixpanelService

+ (void)setupMixpanel
{
    Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:kMixpanelToken];
    NSString *mixpanelUUID = [[NSUserDefaults standardUserDefaults] objectForKey:MixpanelUUID];
    
    if (!mixpanelUUID) {
        mixpanelUUID = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:mixpanelUUID forKey:MixpanelUUID];
    }
    [mixpanel identify:mixpanelUUID];
}

+ (void)trackEventWithType:(BZRMixpanelEventType)eventType properties:(NSDictionary *)properties
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *event;
    
    switch (eventType) {
        case BZRMixpanelEventOpenApp: {
            event = OpenApp;
            break;
        }
        case BZRMixpanelEventSurveyViewed: {
            event = SurveyViewed;
            break;
        }
        case BZRMixpanelEventSurveyCompeted: {
            event = SurveyCompleted;
            break;
        }
        case BZRMixpanelEventSignupPage: {
            event = SignupPage;
            break;
        }
        case BZRMixpanelEventCreateAccountPage: {
            event = CreateAccountPage;
            break;
        }
        case BZRMixpanelEventCreateAcountClicked: {
            event = CreateAcountClicked;
            break;
        }
        case BZRMixpanelEventRegistrationSuccessful: {
            event = RegistrationSuccessful;
            break;
        }
        case BZRMixpanelEventLoginSuccessful: {
            event = LoginSuccessful;
            break;
        }
        case BZRMixpanelEventPushNotificationPermission: {
            event = PushNotificationPermission;
            break;
        }
        case BZRMixpanelEventLocationPermission: {
            event = LocationPermission;
            break;
        }
        case BZRMixpanelEventGeofenceEnter: {
            event = GeofenceEnter;
            break;
        }
        case BZRMixpanelEventGeofenceExit: {
            event = GeofenceExit;
            break;
        }

    }
    if (properties) {
        [mixpanel track:event properties:properties];
    } else {
        [mixpanel track:event];
    }
}

+ (void)setPeopleWithProperties:(NSDictionary *)properties
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people set:properties];
    
}

@end
