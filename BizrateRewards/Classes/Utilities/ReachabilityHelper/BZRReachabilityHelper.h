//
//  BZRReachabilityHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRReachabilityHelper : NSObject

+ (void)checkConnectionOnSuccess:(void (^)())success failure:(void (^)())failure;

+ (BOOL)isInternetAvaliable;
+ (BOOL)checkInternetAndShowAlertInViewController:(UIViewController*)errorController alertClicked:(void (^)())alertClicked;
+ (BOOL)checkConnectionShowingErrorInViewController:(UIViewController*)errorController;

@end
