//
//  BZRFacebookService.h
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^FacebookAuthSuccessBlock)(BOOL isSuccess);
typedef void(^FacebookAuthFailureBlock)(NSError *error, BOOL isCanceled);

typedef void(^FacebookProfileSuccessBlock)(NSDictionary *facebookProfile);
typedef void(^FacebookProfileFailureBlock)(NSError *error);

@interface BZRFacebookService : NSObject

+ (void)authorizeWithFacebookOnSuccess:(FacebookAuthSuccessBlock)success onFailure:(FacebookAuthFailureBlock)failure;

+ (void)getFacebookUserProfileOnSuccess:(FacebookProfileSuccessBlock)success onFailure:(FacebookProfileFailureBlock)failure;

+ (void)authorizeTestFacebookUserOnSuccess:(void(^)(FBSDKAccessToken *token))success onFailure:(FacebookAuthFailureBlock)failure;
+ (void)getTestFacebookUserProfileWithId:(NSString *)userId andWithTokenString:(NSString *)tokenString OnSuccess:(FacebookProfileSuccessBlock)success onFailure:(FacebookProfileFailureBlock)failure;

+ (void)setLoginSuccess:(BOOL)success;
+ (void)logoutFromFacebook;

+ (BOOL)isFacebookSessionValid;

@end
