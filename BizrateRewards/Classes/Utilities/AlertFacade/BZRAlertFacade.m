//
//  BZRAlertFacade.m
//  BizrateRewards
//
//  Created by Eugenity on 03.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAlertFacade.h"

#import "BZRBaseNavigationController.h"

#import "AppDelegate.h"

#import "BZRErrorHandler.h"

NSString *const kErrorAlertTitle = @"AlertTitle";
NSString *const kErrorAlertMessage = @"AlertMessage";

@implementation BZRAlertFacade

#pragma mark - Actions

/**
 *  Show alert if email has already registered
 *
 *  @param error      Error that should be parsed
 *  @param completion Completion Block
 */
+ (void)showEmailAlreadyRegisteredAlertWithError:(NSError *)error andCompletion:(void(^)(void))completion
{
    [self showFailureResponseAlertWithError:error andCompletion:completion];
}

/**
 *  Show geolocation global alert
 *
 *  @param completion Completion Block
 */
+ (void)showGlobalGeolocationPermissionsAlertWithCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"Location services are off") message:LOCALIZED(@"To use background location you must turn on 'Always' in the Location Services Settings") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, YES);
        }
    }];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, NO);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    
    [self showCurrentAlertController:alertController];
}

/**
 *  Show push notifications global alert
 *
 *  @param completion Completion Block
 */
+ (void)showGlobalPushNotificationsPermissionsAlertWithCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"Push-notifications are off") message:LOCALIZED(@"Do you want to enable them from settings?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"NO") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, YES);
        }
    }];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:LOCALIZED(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, NO);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    
    [self showCurrentAlertController:alertController];
}

/**
 *  Show retry internet connection alert
 *
 *  @param completion Completion Block
 */
+ (void)showRetryInternetConnectionAlertWithCompletion:(void(^)(BOOL retry))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Connection failed. Try again?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"NO") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(NO);
        }
    }];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:LOCALIZED(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(YES);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:acceptAction];
    
    [self showCurrentAlertController:alertController];
}

/**
 *  Show change permissions alert
 *
 *  @param accessType BZRAccessType
 *  @param completion Completion Block
 */
+ (void)showChangePermissionsAlertWithAccessType:(BZRAccessType)accessType andCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion
{
    NSString *alertMessage;
    switch (accessType) {
        case BZRAccessTypeGeolocation:
            alertMessage = LOCALIZED(@"Do you want to enable/disable geolocation from settings?");
            break;
        case BZRAccessTypePushNotifications:
            alertMessage = LOCALIZED(@"Do you want to enable/disable push notifications from settings?");
            break;
        default:
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"NO") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, YES);
        }
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        if (completion) {
            completion(action, NO);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self showCurrentAlertController:alertController];
}

#pragma mark - Private methods

/**
 *  Show alert controller
 *
 *  @param alertController Alert Controller that should be presented
 */
+ (void)showCurrentAlertController:(UIAlertController *)alertController
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BZRBaseNavigationController *navigationController = (BZRBaseNavigationController *)appDelegate.window.rootViewController;
    UIViewController *lastPresentedViewController = ((UIViewController *)navigationController.viewControllers.lastObject).presentedViewController;
    
    if (lastPresentedViewController) {
        [lastPresentedViewController presentViewController:alertController animated:YES completion:nil];
    } else {
        [navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Alerts

/**
 *  Show error alert with title and message
 *
 *  @param title      Alert Title
 *  @param error      Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithTitle:(NSString *)title andError:(NSError *)error withCompletion:(void(^)(void))completion
{
    if (!error) {
        return;
    }
    
    NSMutableString *errStr = [NSMutableString stringWithString: LOCALIZED(@"Error")];

    [errStr appendFormat:@"\n%@", error.localizedDescription];
    
    if (error.localizedFailureReason)
        [errStr appendFormat:@"\n%@", error.localizedFailureReason];
    
    if (error.localizedRecoverySuggestion)
        [errStr appendFormat:@"\n%@", error.localizedRecoverySuggestion];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(title) message:errStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion();
        }
    }];
    
    [alertController addAction:okAction];
    [self showCurrentAlertController:alertController];
}

/**
 *  Show alert with error
 *
 *  @param error      Error that should be parsed
 *  @param completion Completion Block
 */
+ (void)showErrorAlert:(NSError *)error withCompletion:(void(^)(void))completion
{
    [self showAlertWithTitle:@"" andError:error withCompletion:completion];
}

/**
 *  Show alert with title and message
 *
 *  @param title      Alert Title
 *  @param message    Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message withCompletion:(void(^)(void))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion();
        }
    }];
    
    [alertController addAction:okAction];
    [self showCurrentAlertController:alertController];
}

/**
 *  Show Alert with message
 *
 *  @param message    Alert Message
 *  @param completion Completion Block
 */
+ (void)showAlertWithMessage:(NSString *)message withCompletion:(void(^)(void))completion
{
    [self showAlertWithTitle:@"" andMessage:message withCompletion:completion];
}

/**
 *  Show response error alert
 *
 *  @param error      Error that shoud be parsed
 *  @param completion Completion Block
 */
+ (void)showFailureResponseAlertWithError:(NSError *)error andCompletion:(void(^)(void))completion
{
    if (!error) {
        return;
    }
    [BZRErrorHandler parseError:error withCompletion:^(NSString *alertTitle, NSString *alertMessage) {
        [self showAlertWithTitle:alertTitle andMessage:alertMessage withCompletion:completion];
    }];
}

@end
