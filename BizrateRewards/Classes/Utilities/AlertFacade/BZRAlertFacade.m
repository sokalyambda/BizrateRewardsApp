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

@implementation BZRAlertFacade

#pragma mark - Actions

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

void ShowTitleErrorAlert(NSString *title, NSError *error)
{
    if (!error) {
        return;
    }
    
    NSMutableString *errStr = [NSMutableString stringWithString: LOCALIZED(@"Error")];
    
    //    if (error.code) {
    //       [errStr appendFormat:@": %ld", (long)error.code];
    //    }
    
    // If the user info dictionary doesn’t contain a value for NSLocalizedDescriptionKey
    // error.localizedDescription is constructed from domain and code by default
    [errStr appendFormat:@"\n%@", error.localizedDescription];
    
    if (error.localizedFailureReason)
        [errStr appendFormat:@"\n%@", error.localizedFailureReason];
    
    if (error.localizedRecoverySuggestion)
        [errStr appendFormat:@"\n%@", error.localizedRecoverySuggestion];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:errStr delegate:nil cancelButtonTitle:LOCALIZED(@"OK") otherButtonTitles:nil];
    
    [alert show];
}

void ShowErrorAlert(NSError *error)
{
    ShowTitleErrorAlert(@"", error);
}

void ShowTitleAlert(NSString *title, NSString *message)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:LOCALIZED(@"OK") otherButtonTitles:nil];
    [alert show];
}

void ShowAlert(NSString *message)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:LOCALIZED(@"OK") otherButtonTitles:nil];
    [alert show];
}

void ShowFailureResponseAlertWithError(NSError *error)
{
    if (!error) {
        return;
    }
    NSString *errorString = [BZRErrorHandler stringFromNetworkError:error];
    ShowAlert(errorString);
}

@end
