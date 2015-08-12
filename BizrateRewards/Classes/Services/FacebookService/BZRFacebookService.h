//
//  BZRFacebookService.h
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class BZRFacebookProfile;

@interface BZRFacebookService : NSObject

typedef void(^FacebookAuthSuccessBlock)(BOOL isSuccess);
typedef void(^FacebookAuthFailureBlock)(NSError *error, BOOL isCanceled);

typedef void(^FacebookProfileSuccessBlock)(BZRFacebookProfile *facebookProfile);
typedef void(^FacebookProfileFailureBlock)(NSError *error);

+ (void)authorizeWithFacebookOnSuccess:(FacebookAuthSuccessBlock)success onFailure:(FacebookAuthFailureBlock)failure;

+ (void)getFacebookUserProfileOnSuccess:(FacebookProfileSuccessBlock)success onFailure:(FacebookProfileFailureBlock)failure;

+ (void)setLoginSuccess:(BOOL)success;
+ (void)logoutFromFacebook;

+ (BOOL)isFacebookSessionValid;

@end
