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

static NSString *const MixpanelAliasID = @"MixpanelAliasID";

// Mixpanel Events

//static NSString *const OpenAppEvent = @"Open App";
//static NSString *const SurveyViewedEvent = @"Survey viewed";
//static NSString *const SurveyCompletedEvent = @"Survey completed";
//static NSString *const SignupPageEvent = @"View Signup Page";
//static NSString *const CreateAccountPageEvent = @"View Create Account Page";
//static NSString *const CreateAcountClickedEvent = @"Create Acount Clicked";
//static NSString *const RegistrationSuccessfulEvent = @"Registration Successful";
//static NSString *const LoginSuccessfulEvent = @"Login Successful";
//static NSString *const PushNotificationPermissionEvent = @"Push Notification Permission";
//static NSString *const LocationPermissionEvent = @"Location Permission";
//static NSString *const GeofenceEnterEvent = @"Geofence Enter";
//static NSString *const GeofenceExitEvent = @"Geofence Exit";

// Mixpanel Parameters

//static NSString *const AuthorizationType = @"Type";
static NSString *const AuthTypeEmail = @"Email";
static NSString *const AuthTypeFacebook = @"Facebook";
//static NSString *const AccessGrantedKey = @"Access Granted";
static NSString *const AccessGrantedKeyYes = @"YES";
static NSString *const AccessGrantedKeyNo = @"NO";

//Mixpanel People Properties

static NSString *const PushNotificationsEnabled = @"Push Notifications Enabled";
static NSString *const GeoLocationEnabled = @"Geo Location Enabled";
static NSString *const FirstNameProperty = @"First Name";
static NSString *const LastNameProperty = @"Last Name";
static NSString *const BizrateIDProperty = @"Bizrate ID";

//Facebook (keys for NSUserDefaults)

static NSString *const FBAccessToken = @"FBAccessToken";
static NSString *const FBAccessTokenExpirationDate = @"FBAccessTokenExpirationDate";
static NSString *const FBLoginSuccess = @"FBLoginSuccess";
static NSString *const FBCurrentProfile = @"FBCurrentProfile";

#endif
