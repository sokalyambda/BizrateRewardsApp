//
//  SEProjectFacade.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRProjectFacade.h"

#import "BZRSessionManager.h"

#import "BZRRequests.h"

#import "BZRApplicationToken.h"

#import "BZRFacebookService.h"
#import "BZRErrorHandler.h"

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

/**
 *  Cancel all operations
 */
+ (void)cancelAllOperations
{
    return [sharedHTTPClient cancelAllOperations];
}

/**
 *  Check whether the operation is in process
 *
 *  @return Returns 'YES' if any opretaion is in process
 */
+ (BOOL)isOperationInProcess
{
    return [[self HTTPClient] isOperationInProcess];
}

#pragma mark - Requests builder

//Authorization Requests
+ (BZRNetworkOperation *)signInWithEmail:(NSString*)email
                             password:(NSString*)password
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(NSError *error, BOOL isCanceled, BOOL emailRegistered))failure
{
    BZRSignInRequest *request = [[BZRSignInRequest alloc] initWithEmail:email andPassword:password];
    
    BZRNetworkOperation* operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        //track mixpanel event
        [BZRMixpanelService trackEventWithType:BZRMixpanelEventLoginSuccessful
                                 propertyValue:kAuthTypeEmail];
        //to avoid FB profile usage when user has been logged with email
        [BZRFacebookService logoutFromFacebook];
        
        BZRSignInRequest *request = (BZRSignInRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.token;
        
        if (success) {
            success(YES);
        }
        
    } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        
        BOOL isEmailRegistered = [BZRErrorHandler isEmailRegisteredFromError:error];
        if (isEmailRegistered) {
            ShowFailureResponseAlertWithError(error);
        }
        if (failure) {
            failure(error, isCanceled, isEmailRegistered);
        }
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
            
            //track mixpanel event
            [BZRMixpanelService trackEventWithType:BZRMixpanelEventRegistrationSuccessful
                                     propertyValue:kAuthTypeEmail];
            
            //to avoid FB profile usage when user has been logged with email
            [BZRFacebookService logoutFromFacebook];
            
            BZRSignUpRequest *request = (BZRSignUpRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            if (success) {
               success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];

    } onFailure:^(NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

+ (BZRNetworkOperation *)resetPasswordWithUserName:(NSString *)userName andNewPassword:(NSString *)newPassword onSuccess:(void (^)(BOOL isSuccess))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation* operation;
    
    [self validateSessionWithType:BZRSessionTypeApplication onSuccess:^(BOOL isSuccess) {
        BZRForgotPasswordRequest *request = [[BZRForgotPasswordRequest alloc] initWithUserName:userName andNewPassword:newPassword];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRForgotPasswordRequest *request = (BZRForgotPasswordRequest*)operation.networkRequest;
            
            if (success) {
                success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
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
            
            //set mixpanel alias
            [BZRMixpanelService setAliasForUser:currentProfile];
            //set mixpanel people
            [BZRMixpanelService setPeopleForUser:currentProfile];
            
            if (success) {
               success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
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
            
            //set mixpanel people
            [BZRMixpanelService setPeopleForUser:request.updatedProfile];
            
            if (success) {
                success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
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
            
            if (success) {
                success(request.eligibleSurveys);
            }
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
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
            
            if (success) {
                success(request.loggedEvent);
            }
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
}

//Device Requests
+ (BZRNetworkOperation *)sendDeviceDataOnSuccess:(void (^)(BOOL isSuccess))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation *operation;
    [self validateSessionWithType:BZRSessionTypeUser onSuccess:^(BOOL isSuccess) {
        BZRSendDeviceDataRequest *request = [[BZRSendDeviceDataRequest alloc] init];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRSendDeviceDataRequest *request = (BZRSendDeviceDataRequest*)operation.networkRequest;
            
            if (success) {
                success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
//            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
}

//GiftCards Requests
+ (BZRNetworkOperation *)getFeaturedGiftCardsOnSuccess:(void (^)(NSArray *giftCards))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    __block BZRNetworkOperation *operation;
    [self validateSessionWithType:BZRSessionTypeUser onSuccess:^(BOOL isSuccess) {
        BZRGetFeaturedGiftcards *request = [[BZRGetFeaturedGiftcards alloc] init];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRGetFeaturedGiftcards *request = (BZRGetFeaturedGiftcards*)operation.networkRequest;
            
            if (success) {
                success(request.featuredGiftCards);
            }
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
}

/**
 *  Sign out from current account
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self cancelAllOperations];
    
    [BZRStorageManager sharedStorage].currentProfile = nil;
    [BZRStorageManager sharedStorage].applicationToken = nil;
    [BZRStorageManager sharedStorage].userToken = nil;
    [BZRStorageManager sharedStorage].facebookProfile = nil;
    
    [BZRKeychainHandler resetKeychain];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RememberMeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [BZRFacebookService logoutFromFacebook];
    
    if (success) {
        success(YES);
    }
}

/**
 *  Session validation, if not valid - renew session token
 *
 *  @param sessionType Type of session (application or user)
 *  @param success     Success Block
 *  @param failure     Failure Block
 */
+ (void)validateSessionWithType:(BZRSessionType)sessionType onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [[self HTTPClient] validateSessionWithType:sessionType onSuccess:success onFailure:failure];
}

/**
 *  Check whether user session is valid
 *
 *  @return Returns 'YES' if user session is valid
 */
+ (BOOL)isUserSessionValid
{
    return [[self HTTPClient] isSessionValidWithType:BZRSessionTypeUser];
}

/**
 *  Check whether facebook session is valid
 *
 *  @return Returns 'YES' if facebook session is valid
 */
+ (BOOL)isFacebookSessionValid
{
    return [BZRFacebookService isFacebookSessionValid];
}

/******* FaceBook *******/

+ (BZRNetworkOperation *)signInWithFacebookOnSuccess:(void (^)(BOOL isSuccess))success
                                           onFailure:(void (^)(NSError *error, BOOL isCanceled, BOOL userExists))failure
{
    __block BZRNetworkOperation* operation;
    
    [self validateSessionWithType:BZRSessionTypeApplication onSuccess:^(BOOL isSuccess) {
        BZRSignInWithFacebookRequest *request = [[BZRSignInWithFacebookRequest alloc] init];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            //track mixpanel event
            [BZRMixpanelService trackEventWithType:BZRMixpanelEventLoginSuccessful
                                     propertyValue:kAuthTypeFacebook];
            
            BZRSignInWithFacebookRequest *request = (BZRSignInWithFacebookRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            if (success) {
                success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            
            BOOL isFacebookUserExists = [BZRErrorHandler isFacebookUserExistsFromError:error];
            if (isFacebookUserExists) {
                ShowFailureResponseAlertWithError(error);
            }
            if (failure) {
                failure(error, isCanceled, isFacebookUserExists);
            }
        }];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        BOOL isFacebookUserExists = [BZRErrorHandler isFacebookUserExistsFromError:error];
        if (failure) {
            failure(error, isCanceled, isFacebookUserExists);
        }
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
        
        //track mixpanel event
        [BZRMixpanelService trackEventWithType:BZRMixpanelEventRegistrationSuccessful
                                 propertyValue:kAuthTypeFacebook];
        
        BZRSignUpRequest *request = [[BZRSignUpRequest alloc] initWithUserFirstName:firstName andUserLastName:lastName andEmail:email andDateOfBirth:dateOfBirth andGender:gender];
        
        operation = [[self  HTTPClient] enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
            
            BZRSignUpRequest *request = (BZRSignUpRequest*)operation.networkRequest;
            
            [BZRStorageManager sharedStorage].userToken = request.userToken;
            
            if (success) {
                success(YES);
            }
            
        } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
            ShowFailureResponseAlertWithError(error);
            if (failure) {
                failure(error, isCanceled);
            }
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    
    return operation;
}

/******* FaceBook *******/

+ (BOOL)isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end
