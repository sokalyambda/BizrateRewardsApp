//
//  BZRAlertFacade.h
//  BizrateRewards
//
//  Created by Eugenity on 03.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRAccessTypeGeolocation,
    BZRAccessTypePushNotifications
} BZRAccessType;

@interface BZRAlertFacade : NSObject

//Geolocation permissions alert
+ (void)showGlobalGeolocationPermissionsAlertWithCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

//Push-notifications permissions alert
+ (void)showGlobalPushNotificationsPermissionsAlertWithCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

//Retry internet connection
+ (void)showRetryInternetConnectionAlertWithCompletion:(void(^)(BOOL retry))completion;

//Change permissions
+ (void)showChangePermissionsAlertWithAccessType:(BZRAccessType)accessType andCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

//Alerts functions
void ShowTitleErrorAlert(NSString *title, NSError *error);
void ShowErrorAlert(NSError *error);
void ShowTitleAlert(NSString *title, NSString *message);
void ShowAlert(NSString *message);
void ShowFailureResponseAlertWithError(NSError *error);

@end
