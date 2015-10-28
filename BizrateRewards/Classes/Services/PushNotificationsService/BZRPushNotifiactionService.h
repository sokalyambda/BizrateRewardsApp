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
+ (void)saveAndSendDeviceData:(NSString *)deviceToken;

+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken;
+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error;

+ (BOOL)pushNotificationsEnabled;

+ (void)cleanPushNotificationsBadges;

@end
