//
//  BZRPushNotifiactionService.m
//  BizrateRewards
//
//  Created by Eugenity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

#import "BZRPushNotifiactionService.h"

#import "BZRStorageManager.h"

#import "BZRProjectFacade.h"

static NSString *const kPushPermissionsLastState = @"pushPermissionLastState";

@implementation BZRPushNotifiactionService

/**
 *  Called when application successfully registered for remote notifications and device token has been received
 *
 *  @param deviceToken Current Device Token
 */
+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken
{
    NSString *token = [[[deviceToken.description
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self saveAndSendDeviceData:token];
    [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationServiceDidSuccessAuthorizeNotification object:nil];
}

/**
 *  Called when application is failed to register for push notifications
 *
 *  @param error Error
 */
+ (void)failedToRegisterForPushNotificationsWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationServiceDidFailAuthorizeNotification object:error];
}

/**
 *  Registering application for push notifications
 *
 *  @param application Application that will be registered
 */
+ (void)registerApplicationForPushNotifications:(UIApplication *)application
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [application registerUserNotificationSettings:settings];
}

/**
 *  Checking whether application is registered for push notifications
 *
 *  @return Returns 'YES' if registered
 */
+ (BOOL)pushNotificationsEnabled
{ 
    BOOL isPushesEnabled = [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    
    [self checkForPermissionsChangingWithPushesEnabled:isPushesEnabled];
    
    return isPushesEnabled;
}

/**
 *  Called when applications received the remote notifications
 *
 *  @param userInfo Push notification info dictionary
 */
+ (void)recivedPushNotification:(NSDictionary*)userInfo
{
    
}

/**
 *  Save devicet token and send device data to server
 */
+ (void)saveAndSendDeviceData:(NSString *)deviceToken
{
    BOOL enabled = [self pushNotificationsEnabled];
    if (!enabled) {
        deviceToken = nil;
        return;
    }
    if (deviceToken.length && [BZRProjectFacade isUserSessionValid]) {
        [BZRStorageManager sharedStorage].deviceToken = deviceToken;
//        [BZRProjectFacade sendDeviceDataOnSuccess:^(BOOL isSuccess) {
//            
//        } onFailure:^(NSError *error, BOOL isCanceled) {
//            
//        }];
    }
}

#pragma mark - Private methods

/**
 *  Track the changing permissions event
 *
 *  @param isPushesEnabled Enable value
 */
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
        
        //track mixpanel event
        [BZRMixpanelService trackEventWithType:BZRMixpanelEventPushNotificationPermission
                                 propertyValue:isPushesEnabled? @"YES" : @"NO"];
    }
}

@end
