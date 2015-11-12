//
//  BZRFacebookService.h
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class FacebookProfile;

@interface BZRFacebookService : NSObject

typedef void(^FacebookAuthSuccessBlock)(BOOL isSuccess);
typedef void(^FacebookAuthFailureBlock)(NSError *error, BOOL isCanceled);

typedef void(^FacebookProfileSuccessBlock)(FacebookProfile *facebookProfile);
typedef void(^FacebookProfileFailureBlock)(NSError *error);

+ (void)authorizeWithFacebookFromController:(UIViewController *)fromController
                                  onSuccess:(FacebookAuthSuccessBlock)success
                                  onFailure:(FacebookAuthFailureBlock)failure;

+ (void)getFacebookUserProfileOnSuccess:(FacebookProfileSuccessBlock)success onFailure:(FacebookProfileFailureBlock)failure;

+ (void)setLoginSuccess:(BOOL)success;
+ (void)logoutFromFacebook;

+ (BOOL)isFacebookSessionValid;

@end
