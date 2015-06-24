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
typedef void(^ImageUserBlock)(BOOL success, UIImage *image);

@interface BZRNetworkManager : AFHTTPSessionManager

//sign up/in
- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(UserProfileBlock)result;
- (void)signUpWithUserName:(NSString *)userName password:(NSString *)password withResult:(UserProfileBlock)result;

- (void)signInWithFacebookWithResult:(UserProfileBlock)result;
- (void)signUpWithFacebookWithResult:(UserProfileBlock)result;

//post image
- (void)postImage:(UIImage *)image withID:(NSInteger)ID result:(ImageUserBlock)result;

@end
