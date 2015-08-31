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

extern NSString *const kErrorAlertTitle;
extern NSString *const kErrorAlertMessage;

@interface BZRAlertFacade : NSObject

//Geolocation permissions alert
+ (void)showGlobalGeolocationPermissionsAlertForController:(UIViewController *)controller withCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

//Push-notifications permissions alert
+ (void)showGlobalPushNotificationsPermissionsAlertForController:(UIViewController *)controller withCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

//Retry internet connection
+ (void)showRetryInternetConnectionAlertForController:(UIViewController *)controller withCompletion:(void(^)(BOOL retry))completion;
//Email has already been registered
+ (void)showEmailAlreadyRegisteredAlertWithError:(NSError *)error forController:(UIViewController *)controller andCompletion:(void(^)(void))completion;

//Change permissions
+ (void)showChangePermissionsAlertWithAccessType:(BZRAccessType)accessType forController:(UIViewController *)controller andCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

//Common alerts methods
+ (void)showFailureResponseAlertWithError:(NSError *)error forController:(UIViewController *)controller andCompletion:(void(^)(void))completion;
+ (void)showAlertWithTitle:(NSString *)title andError:(NSError *)error forController:(UIViewController *)controller withCompletion:(void(^)(void))completion;
+ (void)showErrorAlert:(NSError *)error forController:(UIViewController *)controller withCompletion:(void(^)(void))completion;
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message forController:(UIViewController *)currentController withCompletion:(void(^)(void))completion;
+ (void)showAlertWithMessage:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)(void))completion;

@end
