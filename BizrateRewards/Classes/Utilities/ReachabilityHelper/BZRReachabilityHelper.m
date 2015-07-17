//
//  BZRReachabilityHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRReachabilityHelper.h"

#import "BZRDataManager.h"

@implementation BZRReachabilityHelper

+ (void)checkConnectionOnSuccess:(void (^)())success failure:(void (^)())failure
{
    BOOL isInternetAvaliable= [self isInternetAvaliable];
    if (isInternetAvaliable) {
        if (success) {
            success();
        }
    } else {
        if (failure) {
            failure();
        }
    }
}

+ (BOOL)checkConnectionShowingErrorInViewController:(UIViewController*)errorController
{
    BOOL isInternet = [self isInternetAvaliable];
    
    if (!isInternet) {
        //show alert
    }
    return isInternet;
}

+ (BOOL)checkInternetAndShowAlertInViewController:(UIViewController*)errorController alertClicked:(void (^)())alertClicked
{
    BOOL internetAvaliable = [self isInternetAvaliable];
    
    __strong  void(^strongAlertClicked)() = alertClicked;
    
    if (!internetAvaliable) {
        //show alert
    }
    
    return internetAvaliable;
}

+ (BOOL)isInternetAvaliable
{
    return [BZRDataManager sharedInstance].isReachable;
}

@end
