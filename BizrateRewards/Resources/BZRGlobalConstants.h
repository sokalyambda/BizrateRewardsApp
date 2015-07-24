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

static NSString *const MixpanelID = @"MixpanelID";
static NSString *const BizID = @"BizID";

// Mixpanel Events

static NSString *const OpenApp = @"Open App";
static NSString *const SurveyViewed = @"Survey viewed";
static NSString *const SurveyCompleted = @"Survey completed";
static NSString *const SignupPage = @"View Signup Page";
static NSString *const CreateAccountPage = @"View Create Account Page";
static NSString *const CreateAcountClicked = @"Create Acount Clicked";
static NSString *const RegistrationSuccessful = @"Registration Successful";
static NSString *const LoginSuccessful = @"Login Successful";
static NSString *const PushNotificationPermission = @"Push Notification Permission";
static NSString *const LocationPermission = @"Location Permission";
static NSString *const GeofenceEnter = @"Geofence Enter";
static NSString *const GeofenceExit = @"Geofence Exit";

// Mixpanel Parameters

static NSString *const Type = @"Type";
static NSString *const AuthTypeEmail = @"Email";
static NSString *const AuthTypeFacebook = @"Facebook";
static NSString *const AccessGrantedKey = @"Access Granted";
static NSString *const Yes = @"YES";
static NSString *const No = @"NO";

//Mixpanel People Properties

static NSString *const PushNotificationsEnabled = @"Push Notifications Enabled";
static NSString *const GeoLocationEnabled = @"Geo Location Enabled";
static NSString *const FirstName = @"First Name";
static NSString *const LastName = @"Last Name";
static NSString *const BizrateID = @"Bizrate ID";

#endif
