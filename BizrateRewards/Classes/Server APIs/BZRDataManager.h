//
//  BZRDataManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRSessionTypeApplication,
    BZRSessionTypeUser
} BZRSessionType;

#import "BZRNetworkManager.h"
#import "BZRStorageManager.h"

#import "BZRApiConstants.h"

@interface BZRDataManager : NSObject

@property (assign, nonatomic) BOOL isReachable;

+ (BZRDataManager *)sharedInstance;

//Authorization
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

- (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

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
- (void)sendDeviceAPNSTokenAndDeviceIdentifierOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (BOOL)isSessionValidWithType:(BZRSessionType)type;

@end
