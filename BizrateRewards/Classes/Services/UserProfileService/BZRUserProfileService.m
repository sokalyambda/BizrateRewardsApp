//
//  BZRUserProfileService.m
//  BizrateRewards
//
//  Created by Eugenity on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRUserProfileService.h"

#import "BZRDataManager.h"

@implementation BZRUserProfileService

+ (void)getCurrentUserOnSuccess:(UserProfileSuccessBlock)success onFailure:(UserProfileFailureBlock)failure
{
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        
        [[BZRDataManager sharedInstance] validateSessionWithType:BZRSessionTypeUser withCompletion:^(BOOL isValid, NSError *error) {
            
            if (isValid) {
                [[BZRDataManager sharedInstance] getCurrentUserOnSuccess:^(id responseObject) {
                    
                    BZRUserProfile *currentUserProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
                    [BZRStorageManager sharedStorage].currentProfile = currentUserProfile;
                    success(currentUserProfile);
                    
                } onFailure:^(NSError *error) {
                    failure(error);
                }];
            } else {
                failure(error);
            }
            
        }];
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
        failure(nil);
    }];
}

+ (void)updateCurrentUserWithFirstName:(NSString *)firstName
                           andLastName:(NSString *)lastName
                        andDateOfBirth:(NSString *)dateOfBirth
                             andGender:(NSString *)gender
                             onSuccess:(UserProfileSuccessBlock)success onFailure:(UserProfileFailureBlock)failure
{
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        
        [[BZRDataManager sharedInstance] validateSessionWithType:BZRSessionTypeUser withCompletion:^(BOOL isValid, NSError *error) {
            
            if (isValid) {
                [[BZRDataManager sharedInstance] updateCurrentUserWithFirstName:firstName andLastName:lastName andDateOfBirth:dateOfBirth andGender:gender onSuccess:^(id responseObject) {
                    
                    BZRUserProfile *updatedProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
                    [BZRStorageManager sharedStorage].currentProfile = updatedProfile;
                    success(updatedProfile);
                    
                } onFailure:^(NSError *error) {
                    failure(error);
                }];
            } else {
                failure(error);
            }
        }];
        
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
        failure(nil);
    }];
}

@end
