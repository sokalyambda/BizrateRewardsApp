//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"

#import <Mixpanel.h>

static NSString *const kMixpanelToken = @"f818411581cc210c670fe3351a46debe";//@"aae3e2388125817b27b8afcf99093d97";

@implementation BZRMixpanelService


+ (void)setupMixpanel
{
    Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:kMixpanelToken];
    NSString *mixpanelID = [[NSUserDefaults standardUserDefaults] objectForKey:MixpanelID];
    
    if (!mixpanelID) {
        mixpanelID = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:mixpanelID forKey:MixpanelID];
        [defaults synchronize];
    }
    [mixpanel identify:mixpanelID];
}

+ (void)trackEventWithType:(BZRMixpanelEventType)eventType properties:(NSDictionary *)properties
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *event;
    
    switch (eventType) {
        case BZRMixpanelEventOpenApp: {
            event = OpenAppEvent;
            
            break;
        }
        case BZRMixpanelEventSurveyViewed: {
            event = SurveyViewedEvent;
            break;
        }
        case BZRMixpanelEventSurveyCompeted: {
            event = SurveyCompletedEvent;
            break;
        }
        case BZRMixpanelEventSignupPage: {
            event = SignupPageEvent;
            break;
        }
        case BZRMixpanelEventCreateAccountPage: {
            event = CreateAccountPageEvent;
            break;
        }
        case BZRMixpanelEventCreateAcountClicked: {
            event = CreateAcountClickedEvent;
            break;
        }
        case BZRMixpanelEventRegistrationSuccessful: {
            event = RegistrationSuccessfulEvent;
            break;
        }
        case BZRMixpanelEventLoginSuccessful: {
            event = LoginSuccessfulEvent;
            break;
        }
        case BZRMixpanelEventPushNotificationPermission: {
            event = PushNotificationPermissionEvent;
            break;
        }
        case BZRMixpanelEventLocationPermission: {
            event = LocationPermissionEvent;
            break;
        }
        case BZRMixpanelEventGeofenceEnter: {
            event = GeofenceEnterEvent;
            break;
        }
        case BZRMixpanelEventGeofenceExit: {
            event = GeofenceExitEvent;
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
    NSString  *bizID = [[NSUserDefaults standardUserDefaults] objectForKey:MixpanelAliasID];
    if (!bizID) {
        bizID = [properties objectForKey:BizrateIDProperty];
        [mixpanel createAlias:bizID forDistinctID:mixpanel.distinctId];
        [mixpanel identify:mixpanel.distinctId];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:bizID forKey:MixpanelAliasID];
        [defaults synchronize];
    }    
    [mixpanel.people set:properties];
}

@end
