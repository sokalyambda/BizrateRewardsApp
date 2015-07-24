//
//  BZRUserProfileService.h
//  BizrateRewards
//
//  Created by Eugenity on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class BZRUserProfile;

typedef void(^UserProfileSuccessBlock)(BZRUserProfile *userProfile);
typedef void(^UserProfileFailureBlock)(NSError *error);

typedef void(^FacebookUserProfile)(NSDictionary *facebookProfile);

@interface BZRUserProfileService : NSObject

+ (void)getCurrentUserOnSuccess:(UserProfileSuccessBlock)success
                      onFailure:(UserProfileFailureBlock)failure;

+ (void)updateCurrentUserWithFirstName:(NSString *)firstName
                           andLastName:(NSString *)lastName
                        andDateOfBirth:(NSString *)dateOfBirth
                             andGender:(NSString *)gender
                             onSuccess:(UserProfileSuccessBlock)success onFailure:(UserProfileFailureBlock)failure;

+ (void)getFacebookUserProfileOnSuccess:(FacebookUserProfile)success
                              onFailure:(UserProfileFailureBlock)failure;

@end
