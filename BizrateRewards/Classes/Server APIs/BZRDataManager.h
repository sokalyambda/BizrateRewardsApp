//
//  BZRDataManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkManager.h"
#import "BZRStorageManager.h"

#import "BZRApiConstants.h"

@interface BZRDataManager : NSObject

@property (assign, nonatomic) BOOL isReachable;

+ (BZRDataManager *)sharedInstance;

//Authorization
- (void)getClientCredentialsOnSuccess:(SuccessBlock)completion;

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result;

- (void)signUpWithUserFirstName:(NSString *)firstName
                andUserLastName:(NSString *)lastName
                       andEmail:(NSString *)email
                    andPassword:(NSString *)password
                 andDateOfBirth:(NSString *)birthDate
                      andGender:(NSString *)gender
                     withResult:(SuccessBlock)result;

- (void)authorizeWithFacebookWithResult:(SuccessBlock)result;

- (void)signOutOnSuccess:(SuccessBlock)result;

//get user
- (void)getCurrentUserWithCompletion:(SuccessBlock)completion;

//getSurvey
- (void)getSurveysListWithResult:(SurveysBlock)result;

//update user
- (void)updateCurrentUserWithFirstName:(NSString *)firstName
                           andLastName:(NSString *)lastName
                        andDateOfBirth:(NSString *)dateOfBirth
                             andGender:(NSString *)gender
                        withCompletion:(SuccessBlock)completion;

//send device token
- (void)sendDeviceAPNSTokenAndDeviceIdentifierWithResult:(SuccessBlock)result;

@end
