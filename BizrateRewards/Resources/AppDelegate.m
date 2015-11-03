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

static NSString *const kHockeyAppBetaIdentifier = @"58315ada266550380341a1b283654d02";
//static NSString *const kHockeyAppProductionIdentifier = @"c451b1dd35fc4db43a265d8ea7b7ce5a";

static NSString *const kOfferBeamRetailerID = @"6F8E3A94-FE29-4144-BE86-AA8372D1D407";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Reset keychain if it's a first launch of an app
    [BZRKeychainHandler resetKeychainIfFirstLaunch];
    
    /*
     If app was opened with push
     */
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BZRPushNotifiactionService receivedPushNotification:userInfo withApplicationState:UIApplicationStateInactive];
    }
    
    /*
     If app was opened with URL
     */
    NSError *error;
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    [BZRRedirectionHelper redirectWithURL:url withError:&error];

    //setup mixPanel service
    [BZRMixpanelService setupMixpanel];
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventOpenApp propertyValue:nil];
    
    //setup hockey app service
//    [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:kHockeyAppBetaIdentifier liveIdentifier:kHockeyAppProductionIdentifier delegate:nil];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppBetaIdentifier];
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
    
    //clean badge count
    [BZRPushNotifiactionService cleanPushNotificationsBadges];
    
    [BZRPushNotifiactionService pushNotificationsEnabledWithCompletion:^(BOOL enabled, BOOL isPermissionStateChanged) {
        if (!enabled && isPermissionStateChanged) {
            [BZRPushNotifiactionService failedToRegisterForPushNotificationsWithError:nil];
        } else if (isPermissionStateChanged) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PushNotificationServiceDidSuccessAuthorizeNotification object:nil];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //clean badge count
    [BZRPushNotifiactionService cleanPushNotificationsBadges];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSError *error;
    [BZRRedirectionHelper redirectWithURL:url withError:&error];
    
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
    [BZRPushNotifiactionService receivedPushNotification:userInfo
                                   withApplicationState:application.applicationState];
}

@end
