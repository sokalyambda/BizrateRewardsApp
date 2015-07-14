//
//  BZRNetworkManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "BZRUserProfile.h"
#import "BZRUserToken.h"
#import "BZRSurvey.h"

#import "BZRApiConstants.h"

typedef void(^SuccessBlock)(BOOL success, NSError *error, NSInteger responseStatusCode);

typedef void(^SuccessUserTokenBlock)(BOOL success, BZRUserToken *userToken, NSError *error, NSInteger responseStatusCode);
typedef void(^SuccessApplicationTokenBlock)(BOOL success, BZRApplicationToken *appToken, NSError *error);

typedef void(^UserProfileBlock)(BOOL success, BZRUserProfile *userProfile, NSError *error);
typedef void(^FacebookProfileBlock)(BOOL success, NSDictionary *facebookProfile, NSString *faceBookAccessToken, NSError *error);
typedef void(^ImageUserBlock)(BOOL success, UIImage *image);

typedef void(^SurveyBlock)(BOOL success, BZRSurvey *survey, NSError *error);

@interface BZRNetworkManager : AFHTTPSessionManager

@property (assign, nonatomic) AFNetworkReachabilityStatus reachabilityStatus;

//sign up/in
- (void)getClientCredentialsOnCompletion:(SuccessApplicationTokenBlock)completion;

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessUserTokenBlock)result;

- (void)signUpWithUserFirstName:(NSString *)firstName andUserLastName:(NSString *)lastName andEmail:(NSString *)email withResult:(SuccessBlock)result;

- (void)authorizeWithFacebookWithResult:(UserProfileBlock)result;

//get user
- (void)getCurrentUserWithCompletion:(UserProfileBlock)completion;

//update user
- (void)updateCurrentUserWithFirstName:(NSString *)firstName
                           andLastName:(NSString *)lastName
                        andDateOfBirth:(NSString *)dateOfBirth
                             andGender:(NSString *)gender
                        withCompletion:(UserProfileBlock)completion;

//send device token
- (void)sendDeviceAPNSToken:(NSString *)token andDeviceIdentifier:(NSString *)udid withResult:(SuccessBlock)result;

//getSurvey
- (void)getSurveyWithResult:(SurveyBlock)result;

//post image
- (void)postImage:(UIImage *)image withID:(NSInteger)ID result:(ImageUserBlock)result;

@end
