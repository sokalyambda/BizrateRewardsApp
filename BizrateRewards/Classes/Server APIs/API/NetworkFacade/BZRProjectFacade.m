//
//  SEProjectFacade.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRSessionTypeApplication,
    BZRSessionTypeUser
} BZRSessionType;

#import "BZRProjectFacade.h"

#import "BZRSessionManager.h"
#import "BZRStorageManager.h"

#import "BZRRequests.h"

#import "BZRUserProfile.h"
#import "BZRApplicationToken.h"

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

+ (BZRNetworkOperation *)renewSessionTokenOnSuccess:(void (^)(BOOL isSuccess))success
                                          onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRRenewSessionTokenRequest *request = [[BZRRenewSessionTokenRequest alloc] init];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRRenewSessionTokenRequest *request = (BZRRenewSessionTokenRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.userToken;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
//        ShowFailureResponseAlertWithError(error);
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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BizID];
    
    success(YES);
}

+ (BOOL)isSessionValidWithType:(BZRSessionType)type
{
    NSString *accessToken;
    NSDate *tokenExpirationDate;
    
    switch (type) {
        case BZRSessionTypeApplication: {
            accessToken         = [BZRStorageManager sharedStorage].applicationToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].applicationToken.expirationDate;
            break;
        }
        case BZRSessionTypeUser: {
            accessToken         = [BZRStorageManager sharedStorage].userToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].userToken.expirationDate;
            break;
        }
        default:
            break;
    }
    
    return ((accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending)));
}

+ (void)validateSessionWithType:(BZRSessionType)type withCompletion:(void(^)(BOOL success, NSError *error))completion
{
    NSString *accessToken;
    NSDate *tokenExpirationDate;
    
    switch (type) {
        case BZRSessionTypeApplication: {
            accessToken         = [BZRStorageManager sharedStorage].applicationToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].applicationToken.expirationDate;
            break;
        }
        case BZRSessionTypeUser: {
            accessToken         = [BZRStorageManager sharedStorage].userToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].userToken.expirationDate;
            break;
        }
        default:
            break;
    }
    
    if (!(accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending))) {
        if (type == BZRSessionTypeApplication) {
            completion(NO, nil);
        } else {
            [self renewSessionTokenOnSuccess:^(BOOL isSuccess) {
                completion(isSuccess, nil);
            } onFailure:^(NSError *error, BOOL isCanceled) {
                completion(NO, error);
            }];
        }
    } else {
        completion(YES, nil);
    }
}

/******* FaceBook *******/

- (void)authorizeWithFacebookOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
//    [self tryLoginWithFacebookOnSuccess:^(FBSDKLoginManagerLoginResult *loginResult) {
//        
////        success(loginResult);
//        
//        //        [weakSelf getFacebookUserProfileOnSuccess:^(id responseObject) {
//        //            success(responseObject);
//        //        } onFailure:^(NSError *error) {
//        //            failure(error);
//        //        }];
//        
//        //        [weakSelf.network authorizeWithFacebookWithParameters:@{kFBAccessToken: facebookToken} onSuccess:^(id responseObject) {
//        //
//        //
//        ////        NSURL *userImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", [facebookProfile valueForKey:@"id"]]];
//        //
//        //            success(responseObject);
//        //
//        //        } onFailure:^(NSError *error) {
//        //            failure(error);
//        //        }];
//    } onFailure:^(NSError *error, BOOL isCanceled) {
//        failure(error, isCanceled);
//    }];
}

- (void)tryLoginWithFacebookOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    BOOL isFBinstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    if (isFBinstalled) {
        loginManager.loginBehavior = FBSDKLoginBehaviorNative;
    } else {
        loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    }
    
    [loginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            failure(error, result.isCancelled);
        } else {
            if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"]) {
                
                //                NSString *facebookToken = result.token.tokenString;
                success(YES);
            }
        }
    }];
}

- (void)getFacebookUserProfileOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, name, email" forKey:@"fields"];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id response, NSError *error) {
        if (error) {
            failure(error, NO);
        } else {
            //            NSDictionary *user = (NSDictionary *)response;
            //            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"facebook_id":[user valueForKey:@"id"], @"first_name":[user valueForKey:@"first_name"], @"last_name":[user valueForKey:@"last_name"]}];
            //
            //            NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
            success(YES);
        }
    }];
}

/******* FaceBook *******/

+ (BOOL)isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
