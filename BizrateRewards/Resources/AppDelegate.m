//
//  AppDelegate.m
//  BizrateRewards
//
//  Created by Eugenity on 22.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "AppDelegate.h"

#import "BZRPushNotifiactionService.h"

#import "BZRProjectFacade.h"

#import "OB_Services.h"

#import "BZRRedirectionHelper.h"
#import "BZRKeychainHandler.h"

#import "BZRBaseNavigationController.h"

#import "BZRLocationEvent.h"

@import HockeySDK;

static NSString *const kHockeyAppIdentifier = @"bf52cc6c526a07761d1b50a4078b6d67";

static NSString *const kOfferBeamRetailerID = @"A27C65B0-DB22-11E4-8830-0800200C9A66";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Reset keychain if it's a first launch of an app
    [BZRKeychainHandler resetKeychainIfFirstLaunch];
    
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    [BZRRedirectionHelper showResetPasswordResultControllerWithObtainedURL:url];
    
    //setup mixPanel service
    [BZRMixpanelService setupMixpanel];
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventOpenApp propertyValue:nil];
    
    //setup hockey app service
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppIdentifier];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [[BITHockeyManager sharedHockeyManager] startManager];
    
    //setup OfferBeam service
    [OB_Services start];
    [OB_Services setRetailerCode:kOfferBeamRetailerID];
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [BZRRedirectionHelper showResetPasswordResultControllerWithObtainedURL:url];
    
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
