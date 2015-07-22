//
//  BZRGlobalConstants.h
//  BizrateRewards
//
//  Created by Eugenity on 30.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#ifndef BizrateRewards_BZRGlobalConstants_h
#define BizrateRewards_BZRGlobalConstants_h

//Notifications

static NSString *const LocationManagerDidSuccessAuthorizeNotification = @"LocationManagerDidSuccessAuthorizeNotification";
static NSString *const LocationManagerDidFailAuthorizeNotification = @"LocationManagerDidFailAuthorizeNotification";

static NSString *const PushNotificationServiceDidSuccessAuthorizeNotification = @"PushNotificationServiceDidSuccessAuthorizeNotification";
static NSString *const PushNotificationServiceDidFailAuthorizeNotification = @"PushNotificationServiceDidFailAuthorizeNotification";

//Strings

static NSString *const InternetIsNotReachableString = @"Internet is not reachable.";

//User

static NSString *const CurrentProfileKey = @"CurrentProfileKey";

static NSString *const IsTutorialPassed = @"IsTutorialPassed";
static NSString *const RememberMeKey = @"RememberMeKey";

static NSString *const UserNameKey = @"UsernameKey";
static NSString *const PasswordKey = @"PasswordKey";

static NSString *const MixpanelUUID = @"MixpanelUUID";

// Mixpanel Events

static NSString *const OpenApp = @"App is opened";
static NSString *const SurveyViewed = @"Survey is opened";
static NSString *const SurveyCompleted = @"Survey is completed";
static NSString *const CreateAccountPage = @"Create account page";
static NSString *const RegistrationSuccessful = @"Registration successful";
static NSString *const LoginSuccessful = @"Login successful";
static NSString *const PushNotificationPermission = @"Push notifications permissions";
static NSString *const LocationPermission = @"Location permissions";
static NSString *const GeofenceActivity = @"Geofence activity";

static NSString *const AccessGranted = @"Access Granted";
static NSString *const Yes = @"YES";
static NSString *const No = @"NO";

#endif
