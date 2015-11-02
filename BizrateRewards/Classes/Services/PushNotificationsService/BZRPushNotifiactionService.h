//
//  BZRPushNotifiactionServer.h
//  BizrateRewards
//
//  Created by Euginity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

@interface BZRPushNotifiactionService : NSObject

+ (void)registerApplicationForPushNotifications:(UIApplication *)application;

+ (void)recivedPushNotification:(NSDictionary*)userInfo
           withApplicationState:(UIApplicationState)applicationState;
+ (void)saveAndSendDeviceDataWithTokenString:(NSString *)deviceToken andTokenData:(NSData *)tokenData;

+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken;
+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error;

+ (void)pushNotificationsEnabledWithCompletion:(void(^)(BOOL enabled, BOOL isPermissionsStateChanged))completion;
+ (BOOL)isPushNotificationsEnabled;

+ (void)cleanPushNotificationsBadges;

@end
