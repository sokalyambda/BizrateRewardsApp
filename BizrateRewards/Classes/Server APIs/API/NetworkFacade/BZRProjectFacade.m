//
//  SEProjectFacade.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRProjectFacade.h"

#import "BZRSessionManager.h"
#import "BZRStorageManager.h"

#import "BZRRequests.h"

#import "BZRUserProfile.h"
#import "BZRApplicationToken.h"

#import "BZRFacebookService.h"

#import "BZRKeychainHandler.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static NSString *baseURLString = @"https://api.bizraterewards.com/v1/";

static BZRSessionManager *sharedHTTPClient = nil;

@implementation BZRProjectFacade

#pragma mark - Lifecycle

+ (BZRSessionManager *)HTTPClient
{
    if (!sharedHTTPClient) {
        [self initHTTPClientWithRootPath:baseURLString];
    }
    return sharedHTTPClient;
}

+ (void)initHTTPClientWithRootPath:(NSString*)baseURL
{
    if (sharedHTTPClient) {
        
        [sharedHTTPClient cleanManagersWithCompletionBlock:^{
            
            sharedHTTPClient = nil;
            AFNetworkActivityIndicatorManager.sharedManager.enabled = NO;
            
            sharedHTTPClient = [[BZRSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];

            AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        }];
    } else {
        sharedHTTPClient = [[BZRSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    }
}

#pragma mark - Actions

+ (void)cancelAllOperations
{
    return [sharedHTTPClient cancelAllOperations];
}

#pragma mark - Requests builder

//Authorization Requests
+ (BZRNetworkOperation *)signInWithEmail:(NSString*)email
                             password:(NSString*)password
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRSignInRequest *request = [[BZRSignInRequest alloc] initWithEmail:email andPassword:password];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRSignInRequest *request = (BZRSignInRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.token;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
        failure(error, isCanceled);
    }];
    return operation;
}

+ (BZRNetworkOperation *)signUpWithUserFirstName:(NSString *)firstName
                                 andUserLastName:(NSString *)lastName
                                        andEmail:(NSString *)email
                                     andPassword:(NSString *)password
                                  andDateOfBirth:(NSString *)birthDate
                                       andGender:(NSString *)gender
                                         success:(void (^)(BOOL success))success
                                         failure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation* operation;
    
    [self validateSessionWithType:BZRSessionTypeApplication onSuccess:^(BOOL isSuccess) {
        
        BZRSignUpRequest *request = [[BZRSignUpRequest alloc] initWithUserFirstName:firstName andUserLastName:lastName andEmail:email andPassword:password andDateOfBirth:birthDate andGender:gender];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRSignUpRequest *request = (BZRSignUpRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            success(YES);
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            failure(error, isCanceled);
        }];

    } onFailuer:^(NSError *error, BOOL isCanceled) {
        failure(error, isCanceled);
    }];
    
    return operation;
}

+ (BZRNetworkOperation *)resetPasswordWithUserName:(NSString *)userName andNewPassword:(NSString *)newPassword onSuccess:(void (^)(BOOL isSuccess))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRForgotPasswordRequest *request = [[BZRForgotPasswordRequest alloc] initWithUserName:userName andNewPassword:newPassword];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRForgotPasswordRequest *request = (BZRForgotPasswordRequest*)operation.networkRequest;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
        failure(error, isCanceled);
    }];
    return operation;
}

//User Profile Requests
+ (BZRNetworkOperation *)getCurrentUserOnSuccess:(void (^)(BOOL isSuccess))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation* operation;
    
    [self validateSessionWithType:BZRSessionTypeUser onSuccess:^(BOOL isSuccess) {
        BZRGetCurrentUserRequest *request = [[BZRGetCurrentUserRequest alloc] init];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRGetCurrentUserRequest *request = (BZRGetCurrentUserRequest*)operation.networkRequest;
            
            BZRUserProfile *currentProfile = request.currentUserProfile;
            
            [BZRStorageManager sharedStorage].currentProfile = currentProfile;
            
            [BZRMixpanelService setAliasForUser:currentProfile];
            
            success(YES);
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            failure(error, isCanceled);
        }];
    } onFailuer:^(NSError *error, BOOL isCanceled) {
        failure(error, isCanceled);
    }];
    
    return operation;
}

+ (BZRNetworkOperation *)updateUserWithFirstName:(NSString *)firstName
                                    andLastName:(NSString *)lastName
                                 andDateOfBirth:(NSString *)dateOfBirth
                                      andGender:(NSString *)gender
                                      onSuccess:(void (^)(BOOL success))success
                                        onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation* operation;
    [self validateSessionWithType:BZRSessionTypeUser onSuccess:^(BOOL isSuccess) {
        BZRUpdateCurrentUserRequest *request = [[BZRUpdateCurrentUserRequest alloc] initWithFirstName:firstName andLastName:lastName andDateOfBirth:dateOfBirth andGender:gender];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRUpdateCurrentUserRequest *request = (BZRUpdateCurrentUserRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].currentProfile = request.updatedProfile;
            
            success(YES);
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            failure(error, isCanceled);
        }];
    } onFailuer:^(NSError *error, BOOL isCanceled) {
        failure(error, isCanceled);
    }];
    
    return operation;
}

//Surveys Requests
+ (BZRNetworkOperation *)getEligibleSurveysOnSuccess:(void (^)(NSArray *surveys))success
                                          onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation* operation;
    
    [self validateSessionWithType:BZRSessionTypeUser onSuccess:^(BOOL isSuccess) {
        
        BZRGetEligibleSurveysRequest *request = [[BZRGetEligibleSurveysRequest alloc] init];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRGetEligibleSurveysRequest *request = (BZRGetEligibleSurveysRequest*)operation.networkRequest;
            
            success(request.eligibleSurveys);
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            failure(error, isCanceled);
        }];
    } onFailuer:^(NSError *error, BOOL isCanceled) {
        failure(error, isCanceled);
    }];
    
    return operation;
}

//Location Events
+ (BZRNetworkOperation *)sendGeolocationEvent:(BZRLocationEvent *)locationEvent onSuccess:(void (^)(BZRLocationEvent *locationEvent))success
                                    onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation *operation;
    [self validateSessionWithType:BZRSessionTypeUser onSuccess:^(BOOL isSuccess) {
        
        BZRSendLocationEventRequest *request = [[BZRSendLocationEventRequest alloc] initWithLocationEvent:locationEvent];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRSendLocationEventRequest *request = (BZRSendLocationEventRequest*)operation.networkRequest;
            
            success(request.loggedEvent);
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            failure(error, isCanceled);
        }];
    } onFailuer:^(NSError *error, BOOL isCanceled) {
        
    }];
    return operation;
}

+ (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [BZRStorageManager sharedStorage].currentProfile = nil;
    [BZRStorageManager sharedStorage].applicationToken = nil;
    [BZRStorageManager sharedStorage].userToken = nil;
    
    [BZRKeychainHandler resetKeychain];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RememberMeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [BZRFacebookService logoutFromFacebook];
    
    if (success) {
        success(YES);
    }
}

+ (void)validateSessionWithType:(BZRSessionType)sessionType onSuccess:(SuccessBlock)success onFailuer:(FailureBlock)failure
{
    [[self HTTPClient] validateSessionWithType:sessionType onSuccess:success onFailure:failure];
}

/******* FaceBook *******/

+ (BZRNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation* operation;
    
    [self validateSessionWithType:BZRSessionTypeApplication onSuccess:^(BOOL isSuccess) {
        BZRSignInWithFacebookRequest *request = [[BZRSignInWithFacebookRequest alloc] init];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRSignInWithFacebookRequest *request = (BZRSignInWithFacebookRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            success(YES);
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            failure(error, isCanceled);
        }];
    } onFailuer:^(NSError *error, BOOL isCanceled) {
        failure(error, isCanceled);
    }];
    
    return operation;
}

+ (BZRNetworkOperation *)signUpWithFacebookWithUserFirstName:(NSString *)firstName
                                             andUserLastName:(NSString *)lastName
                                                    andEmail:(NSString *)email
                                              andDateOfBirth:(NSString *)dateOfBirth
                                                   andGender:(NSString *)gender
                                                   onSuccess:(void (^)(BOOL isSuccess))success
                                                   onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation *operation;
    
    [self validateSessionWithType:BZRSessionTypeApplication onSuccess:^(BOOL isSuccess) {
        
        BZRSignUpRequest *request = [[BZRSignUpRequest alloc] initWithUserFirstName:firstName andUserLastName:lastName andEmail:email andDateOfBirth:dateOfBirth andGender:gender];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRSignUpRequest *request = (BZRSignUpRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            success(YES);
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            failure(error, isCanceled);
        }];
        
    } onFailuer:^(NSError *error, BOOL isCanceled) {
        
    }];
    
    return operation;
}

/******* FaceBook *******/

+ (BOOL)isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
