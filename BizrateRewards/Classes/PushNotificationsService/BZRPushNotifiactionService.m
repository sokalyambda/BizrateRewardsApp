//
//  BZRPushNotifiactionService.m
//  BizrateRewards
//
//  Created by Eugenity on 17.10.14.
//  Copyright (c) 2014 thinkmobiles. All rights reserved.
//

#import "BZRPushNotifiactionService.h"

#import "BZRStorageManager.h"

static NSString *const kPushPermissionsLastState = @"pushPermissionLastState";

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
    [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationServiceDidSuccessAuthorizeNotification object:nil];
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
    BOOL isPushesEnabled = [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    
    [self checkForPermissionsChangingWithPushesEnabled:isPushesEnabled];
    
    return isPushesEnabled;
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

#pragma mark - Private methods

+ (void)checkForPermissionsChangingWithPushesEnabled:(BOOL)isPushesEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL permissionsLastState = NO;
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:kPushPermissionsLastState]) {
        permissionsLastState = isPushesEnabled;
        [defaults setBool:permissionsLastState forKey:kPushPermissionsLastState];
    } else {
        permissionsLastState = [defaults boolForKey:kPushPermissionsLastState];
    }
    
    BOOL isPermissionsChanged = permissionsLastState == isPushesEnabled ? NO : YES;
    
    if (isPermissionsChanged) {
        [defaults setBool:isPushesEnabled forKey:kPushPermissionsLastState];
        
        [BZRMixpanelService trackEventWithType:BZRMixpanelEventPushNotificationPermission properties:@{@"Access Granted": isPushesEnabled ? @"YES" : @"NO"}];
    }
}

@end
