//
//  RMPushNotifiactionServer.m
//  PocketGuard
//
//  Created by Петровский Максим on 17.10.14.
//  Copyright (c) 2014 realme. All rights reserved.
//

#import "BZRPushNotifiactionService.h"

#import "BZRStorageManager.h"

@implementation BZRPushNotifiactionService

+ (void)recivedPushNotification:(NSDictionary*)userInfo
{
    
}

+ (void)sendPushToken:(NSData*)pushToken
{
    BOOL enabled = [self pushNotificationsEnabled];
    if (!enabled) {
        pushToken = nil;
    }
}

+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken
{
    NSString *token = [[[deviceToken.description
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (token.length) {
        [BZRStorageManager sharedStorage].deviceToken = token;
    }
}

+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error
{
    
}

+ (BOOL)pushNotificationsEnabled
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        return [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    } else {
        return ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] & UIRemoteNotificationTypeAlert);
    }
}

+ (void)registerApplicationForPushNotifications:(UIApplication *)application
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [application registerUserNotificationSettings:settings];
//    [application registerForRemoteNotifications];
}

@end
