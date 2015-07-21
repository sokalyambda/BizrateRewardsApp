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
- (void)getClientCredentialsOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)signUpWithUserFirstName:(NSString *)firstName
                andUserLastName:(NSString *)lastName
                       andEmail:(NSString *)email
                    andPassword:(NSString *)password
                 andDateOfBirth:(NSString *)birthDate
                      andGender:(NSString *)gender
                     onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)authorizeWithFacebookOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//get user
- (void)getCurrentUserOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//getSurvey
- (void)getSurveysListOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//update user
- (void)updateCurrentUserWithFirstName:(NSString *)firstName
                           andLastName:(NSString *)lastName
                        andDateOfBirth:(NSString *)dateOfBirth
                             andGender:(NSString *)gender
                        onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//send device token
- (void)sendDeviceAPNSToken:(NSString *)token andDeviceIdentifier:(NSString *)udid onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

//post image
- (void)postImage:(UIImage *)image withID:(NSInteger)ID onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

@end
