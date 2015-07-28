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
+ (BZRNetworkOperation *)getClientCredentialsOnSuccess:(void (^)(BOOL success))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    if (![self isApplicationSessionValid]) {
        BZRGetClientCredentialsRequest *request = [[BZRGetClientCredentialsRequest alloc] init];
        
        BZRNetworkOperation *operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRGetClientCredentialsRequest *request = (BZRGetClientCredentialsRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].applicationToken = request.applicationToken;
            
            success(YES);
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            failure(error, isCanceled);
        }];
        return operation;
    } else {
        return nil;
    }
}

+ (BZRNetworkOperation *)signInWithEmail:(NSString*)email
                             password:(NSString*)password
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRSignInRequest *request = [[BZRSignInRequest alloc] initWithEmail:email andPassword:password];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRSignInRequest *request = (BZRSignInRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.userToken;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
//        ShowFailureResponseAlertWithError(error);
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
    BZRSignUpRequest *request = [[BZRSignUpRequest alloc] initWithUserFirstName:firstName andUserLastName:lastName andEmail:email andPassword:password andDateOfBirth:birthDate andGender:gender];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRSignUpRequest *request = (BZRSignUpRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.userToken;
        
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
    BZRGetCurrentUserRequest *request = [[BZRGetCurrentUserRequest alloc] init];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRGetCurrentUserRequest *request = (BZRGetCurrentUserRequest*)operation.networkRequest;
        
        BZRUserProfile *currentProfile = request.currentUserProfile;
        
        [BZRStorageManager sharedStorage].currentProfile = currentProfile;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
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
    BZRUpdateCurrentUserRequest *request = [[BZRUpdateCurrentUserRequest alloc] initWithFirstName:firstName andLastName:lastName andDateOfBirth:dateOfBirth andGender:gender];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRUpdateCurrentUserRequest *request = (BZRUpdateCurrentUserRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].currentProfile = request.updatedProfile;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
        failure(error, isCanceled);
    }];
    return operation;
}

//Surveys Requests
+ (BZRNetworkOperation *)getEligibleSurveysOnSuccess:(void (^)(NSArray *surveys))success
                                          onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRGetEligibleSurveysRequest *request = [[BZRGetEligibleSurveysRequest alloc] init];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRGetEligibleSurveysRequest *request = (BZRGetEligibleSurveysRequest*)operation.networkRequest;
        
        success(request.eligibleSurveys);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
        failure(error, isCanceled);
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

+ (BOOL)isApplicationSessionValid
{
    NSString *accessToken = [BZRStorageManager sharedStorage].applicationToken.accessToken;
    NSDate *tokenExpirationDate = [BZRStorageManager sharedStorage].applicationToken.expirationDate;
    
    return ((accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending)));
}

/******* FaceBook *******/

+ (BZRNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRSignInWithFacebookRequest *request = [[BZRSignInWithFacebookRequest alloc] init];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRSignInWithFacebookRequest *request = (BZRSignInWithFacebookRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.userToken;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
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
    BZRSignUpWithFacebookRequest *request = [[BZRSignUpWithFacebookRequest alloc] initWithUserFirstName:firstName andUserLastName:lastName andEmail:email andDateOfBirth:dateOfBirth andGender:gender];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRSignUpWithFacebookRequest *request = (BZRSignUpWithFacebookRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.userToken;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
        failure(error, isCanceled);
    }];
    return operation;
}

/******* FaceBook *******/

+ (BOOL)isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
