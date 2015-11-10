//
//  BZRPushNotifiactionService.m
//  BizrateRewards
//
//  Created by Eugenity on 17.10.14.
//  Copyright (c) 2014 Connexity. All rights reserved.
//

#import "BZRPushNotifiactionService.h"

#import "BZRProjectFacade.h"

#import "BZRRedirectionHelper.h"

#import <Mixpanel/Mixpanel.h>

static NSString *const kPushPermissionsLastState = @"pushPermissionLastState";

static NSString *const kRedirectedURL = @"redirected_url";

static NSString *const kDefaultLatestSurveyURLString = @"com.bizraterewards://survey/latest";

@implementation BZRPushNotifiactionService

/**
 *  Called when application successfully registered for remote notifications and device token has been received
 *
 *  @param deviceToken Current Device Token
 */
+ (void)registeredForPushNotificationsWithToken:(NSData *)deviceToken
{
    NSString *tokenString = [[[deviceToken.description
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self saveAndSendDeviceDataWithTokenString:tokenString andTokenData:deviceToken];
    
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
+ (void)pushNotificationsEnabledWithCompletion:(void(^)(BOOL enabled, BOOL isPermissionsStateChanged))completion
{
    BOOL isPushesEnabled = [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    
    BOOL isPermissionsChanges = [self checkForPermissionsChangingWithPushesEnabled:isPushesEnabled];
    
    if (completion) {
        completion(isPushesEnabled, isPermissionsChanges);
    }
}

+ (BOOL)isPushNotificationsEnabled
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
+ (void)receivedPushNotification:(NSDictionary*)userInfo
           withApplicationState:(UIApplicationState)applicationState
{
    NSURL *redirectedURL = [NSURL URLWithString:kDefaultLatestSurveyURLString];//userInfo[kRedirectedURL];
    NSError *error;
    [BZRRedirectionHelper redirectWithURL:redirectedURL withError:&error];
}

/**
 *  Save devicet token and send device data to server
 */
+ (void)saveAndSendDeviceDataWithTokenString:(NSString *)deviceToken
                                andTokenData:(NSData *)tokenData
{
    [self pushNotificationsEnabledWithCompletion:^(BOOL enabled, BOOL isPermissionsStateChanged) {
        if (!enabled) {
            return;
        }
        if (deviceToken.length && [BZRProjectFacade isUserSessionValid]) {
            
            [BZRStorageManager sharedStorage].deviceToken = deviceToken;
            
            //Uncomment below lines to show the progress hud added to main window.
            /*
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
             hud.labelText = LOCALIZED(@"Sending device data...");
             [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
             */
            
            if ([BZRProjectFacade isUserSessionValid]) {
                [BZRProjectFacade sendDeviceDataOnSuccess:^(BOOL isSuccess) {
                    
                    //send token to MixPanel
                    Mixpanel *mixpanel = [BZRMixpanelService currentMixpanelProject];
                    [mixpanel identify:mixpanel.distinctId];
                    [mixpanel.people addPushDeviceToken:tokenData];
                    
                    DLog(@"Device token has been sent");
                    
                } onFailure:^(NSError *error, BOOL isCanceled) {
                    
                }];
            }
        }
    }];
    
}

/**
 *  Clean notifications badges
 */
+ (void)cleanPushNotificationsBadges
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - Private methods

/**
 *  Track the changing permissions event
 *
 *  @param isPushesEnabled Enable value
 */
+ (BOOL)checkForPermissionsChangingWithPushesEnabled:(BOOL)isPushesEnabled
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

//        if ([BZRProjectFacade isUserSessionValid] && !isPushesEnabled) {
//            //update notifications and geolocation settings
//            [BZRProjectFacade sendDeviceDataOnSuccess:^(BOOL isSuccess) {
//                
//                DLog(@"notifications access have been updated");
//                
//            } onFailure:^(NSError *error, BOOL isCanceled) {
//                
//            }];
//        }
    }
    return isPermissionsChanged;
}

@end
