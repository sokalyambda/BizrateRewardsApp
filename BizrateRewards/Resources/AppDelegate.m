//
//  AppDelegate.m
//  BizrateRewards
//
//  Created by Eugenity on 22.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "AppDelegate.h"

#import "BZRStorageManager.h"
#import "BZRPushNotifiactionService.h"

@import HockeySDK;

static NSString *const kHockeyAppIdentifier = @"bf52cc6c526a07761d1b50a4078b6d67";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppIdentifier];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [[BITHockeyManager sharedHockeyManager] startManager];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    
    if (![BZRPushNotifiactionService pushNotificationsEnabled]) {
        [BZRPushNotifiactionService failedToRegisterForPushNotificationsWithError:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationServiceDidSuccessAuthorizeNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationDidBecomeActiveNotification object:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    } else {
        [BZRPushNotifiactionService failedToRegisterForPushNotificationsWithError:nil];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BZRPushNotifiactionService registeredForPushNotificationsWithToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [BZRPushNotifiactionService failedToRegisterForPushNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BZRPushNotifiactionService recivedPushNotification:userInfo];
}

@end
