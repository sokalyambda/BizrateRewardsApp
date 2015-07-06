//
//  BZRPushNotifiactionService.m
//  BizrateRewards
//
//  Created by Eugenity on 17.10.14.
//  Copyright (c) 2014 thinkmobiles. All rights reserved.
//

#import "BZRPushNotifiactionService.h"

#import "BZRStorageManager.h"

@implementation BZRPushNotifiactionService

+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken
{
    NSString *token = [[[deviceToken.description
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if (token.length) {
        //MARK: set device token
        [BZRStorageManager sharedStorage].deviceToken = token;
        [BZRStorageManager sharedStorage].deviceUDID = deviceId;
    }
}

+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationServiceDidFailAuthorizeNotification object:error];
}

+ (void)registerApplicationForPushNotifications:(UIApplication *)application
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [application registerUserNotificationSettings:settings];
}

+ (BOOL)pushNotificationsEnabled
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        return [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    } else {
        return ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] & UIUserNotificationTypeAlert);
    }
}

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

@end
