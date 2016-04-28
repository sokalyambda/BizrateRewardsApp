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
    BZRMixpanelEventGeofenceExit,
    BZRMixpanelEventShareWithFacebookClicked,
    BZRMixpanelEventShareWithTwitterClicked,
    BZRMixpanelEventShareWithMessageClicked,
    BZRMixpanelEventShareWithEmailClicked
}BZRMixpanelEventType;

extern NSString *const kAuthTypeEmail;
extern NSString *const kAuthTypeFacebook;

#import <Mixpanel.h>

@class BZRUserProfile;
@class BZRLocationEvent;

@interface BZRMixpanelService : NSObject

+ (Mixpanel *)currentMixpanelInstance;

+ (void)resetMixpanel;
+ (void)trackEventWithType:(BZRMixpanelEventType)eventType propertyValue:(NSString *)propertieValue;
+ (void)trackLocationEvent:(BZRLocationEvent *)locationEvent;
+ (void)setAliasForUser:(BZRUserProfile *)userProfile;
+ (void)setPeopleForUser:(BZRUserProfile *)userProfile;

+ (void)addPushDeviceToken:(NSData *)deviceToken;

@end
