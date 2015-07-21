//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"

#import <Mixpanel.h>

static NSString *const kMixpanelToken = @"f818411581cc210c670fe3351a46debe";

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
        case BZRMixpanelEventCreateAccountPage: {
            event = CreateAccountPage;
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
        case BZRMixpanelEventGeofenceActivity: {
            event = GeofenceActivity;
            break;
        }
    }
    if (properties) {
        [mixpanel track:event properties:properties];
    } else {
        [mixpanel track:event];
    }
}

@end
