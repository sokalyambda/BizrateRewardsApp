//
//  BZRNetworkManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "BZRUserProfile.h"

typedef void(^SuccessBlock)(BOOL success, NSError *error);
typedef void(^UserProfileBlock)(BOOL success, BZRUserProfile *userProfile, NSError *error);

@interface BZRNetworkManager : AFHTTPSessionManager

//sign up/in
- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(UserProfileBlock)result;
- (void)signUpWithUserName:(NSString *)userName password:(NSString *)password withResult:(UserProfileBlock)result;

- (void)signInWithFacebookWithResult:(SuccessBlock)result;
- (void)signUpWithFacebookWithResult:(UserProfileBlock)result;

@end
