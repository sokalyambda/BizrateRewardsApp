//
//  BZRNetworkManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "BZRApiConstants.h"

typedef void(^FacebookProfileBlock)(BOOL success, NSDictionary *facebookProfile, NSString *faceBookAccessToken, NSError *error);

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSError *error);

@interface BZRNetworkManager : AFHTTPSessionManager

@property (assign, nonatomic) AFNetworkReachabilityStatus reachabilityStatus;

//sign up/in
- (void)renewSessionTokenWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)getClientCredentialsWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)signInWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)signUpWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)authorizeWithFacebookOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//get user
- (void)getCurrentUserOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//getSurvey
- (void)getSurveysListOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//update user
- (void)updateCurrentUserWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//send device token
- (void)sendDeviceCredentialsWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//post image
- (void)postImage:(UIImage *)image withID:(NSInteger)ID onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

@end
