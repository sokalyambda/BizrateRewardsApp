//
//  BZRMixpanelService.h
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

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

extern NSString *const kMixpanelAliasID;
extern NSString *const kAuthTypeEmail;
extern NSString *const kAuthTypeFacebook;
extern NSString *const kPushNotificationsEnabled;
extern NSString *const kGeoLocationEnabled;
extern NSString *const kFirstNameProperty;
extern NSString *const kLastNameProperty;
extern NSString *const kBizrateIDProperty;

@class BZRUserProfile;
@class BZRLocationEvent;

@interface BZRMixpanelService : NSObject

+ (void)setMixpanelToken:(NSString *)token;

+ (void)setupMixpanel;
+ (void)trackEventWithType:(BZRMixpanelEventType)eventType propertyValue:(NSString *)propertieValue;
+ (void)trackLocationEvent:(BZRLocationEvent *)locationEvent;
+ (void)setAliasForUser:(BZRUserProfile *)userProfile;
+ (void)setPeopleForUser:(BZRUserProfile *)userProfile;

@end
