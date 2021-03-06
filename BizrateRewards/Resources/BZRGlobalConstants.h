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

static NSString *const IsTutorialPassed     = @"IsTutorialPassed";
static NSString *const RememberMeKey        = @"RememberMeKey";

static NSString *const UserNameKey = @"UsernameKey";
static NSString *const PasswordKey = @"PasswordKey";

static NSString *const IsFirstLaunch = @"IsFirstLaunch";

//Location Events (keys for NSUserDefaults)
static NSString *const LastReceivedLocationEvent = @"LastReceivedLocationEvent";

//Keychain service keys
static NSString *const UserCredentialsKey = @"UserCredentialsKey";
static NSString *const TemporaryCredentialsKey = @"TemporaryCredentialsKey";

#endif
