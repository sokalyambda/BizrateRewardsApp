//
//  BZRPushNotifiactionServer.h
//  BizrateRewards
//
//  Created by Euginity on 17.10.14.
//  Copyright (c) 2014 realme. All rights reserved.
//

@interface BZRPushNotifiactionService : NSObject

+ (void)registerApplicationForPushNotifications:(UIApplication *)application;

+ (void)recivedPushNotification:(NSDictionary*)userInfo;
+ (void)sendPushToken:(NSData*)pushToken;
+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken;
+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error;

+ (BOOL)pushNotificationsEnabled;

@end
