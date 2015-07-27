//
//  SEProjectFacade.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "BZRSessionManager.h"

@class BZRUserProfile;

@interface BZRProjectFacade : NSObject

+ (BZRSessionManager *)HTTPClient;

+ (BOOL)isInternetReachable;

//Authorization Requests
+ (BZRNetworkOperation*)getClientCredentialsOnSuccess:(void (^)(BOOL success))success
                                            onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (BZRNetworkOperation*)signInWithEmail:(NSString*)email
                              password:(NSString*)password
                               success:(void (^)(BOOL success))success
                               failure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (BZRNetworkOperation*)signUpWithUserFirstName:(NSString *)firstName
                                andUserLastName:(NSString *)lastName
                                       andEmail:(NSString *)email
                                    andPassword:(NSString *)password
                                 andDateOfBirth:(NSString *)birthDate
                                      andGender:(NSString *)gender
                                        success:(void (^)(BOOL success))success
                                        failure:(void (^)(NSError *error, BOOL isCanceled))failure;

//User Profile Requests
+ (BZRNetworkOperation*)getCurrentUserOnSuccess:(void (^)(BOOL isSuccess))success
                                      onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (BZRNetworkOperation*)updateUserWithFirstName:(NSString *)firstName
                                    andLastName:(NSString *)lastName
                                 andDateOfBirth:(NSString *)dateOfBirth
                                      andGender:(NSString *)gender
                                      onSuccess:(void (^)(BOOL success))success
                                      onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

//Surveys Requests
+ (BZRNetworkOperation*)getEligibleSurveysOnSuccess:(void (^)(NSArray *surveys))success
                                          onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

@end
