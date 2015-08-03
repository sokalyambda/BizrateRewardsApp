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

@implementation BZRAlertFacade

+ (void)showGlobalGeolocationPermissionsAlertWithCompletion:(void(^)(UIAlertAction *action))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"Location services are off") message:LOCALIZED(@"To use background location you must turn on 'Always' in the Location Services Settings") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action);
        }
    }];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BZRBaseNavigationController *navigationController = (BZRBaseNavigationController *)appDelegate.window.rootViewController;
    [navigationController presentViewController:alertController animated:YES completion:nil];
}

@end
