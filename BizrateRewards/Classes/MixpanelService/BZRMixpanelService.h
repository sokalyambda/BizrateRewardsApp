//
//  BZRMixpanelService.h
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class BZRUserProfile;

typedef enum : NSUInteger {
    BZRMixpanelEventOpenApp,
    BZRMixpanelEventSurveyViewed,
    BZRMixpanelEventSurveyCompeted,
    BZRMixpanelEventSignupPage,
    BZRMixpanelEventCreateAccountPage,
    BZRMixpanelEventCreateAcountClicked,
    BZRMixpanelEventRegistrationSuccessful,
    BZRMixpanelEventLoginSuccessful,
    BZRMixpanelEventPushNotificationPermission,
    BZRMixpanelEventLocationPermission,
    BZRMixpanelEventGeofenceEnter,
    BZRMixpanelEventGeofenceExit
}BZRMixpanelEventType;

@interface BZRMixpanelService : NSObject

+ (void)setupMixpanel;
+ (void)trackEventWithType:(BZRMixpanelEventType)eventType propertyValue:(NSString *)propertieValue;
+ (void)setAliasForUser:(BZRUserProfile *)userProfile;
+ (void)setPeopleForUser:(BZRUserProfile *)userProfile;


@end
