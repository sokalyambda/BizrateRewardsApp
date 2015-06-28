//
//  BZRNetworkManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "BZRUserProfile.h"
#import "BZRToken.h"

#import "BZRApiConstants.h"

typedef void(^SuccessBlock)(BOOL success, NSError *error);
typedef void(^SuccessTokenBlock)(BOOL success, BZRToken *token, NSError *error);
typedef void(^UserProfileBlock)(BOOL success, BZRUserProfile *userProfile, NSError *error);
typedef void(^FacebookProfileBlock)(BOOL success, NSDictionary *facebookProfile, NSString *faceBookAccessToken, NSError *error);
typedef void(^ImageUserBlock)(BOOL success, UIImage *image);

@interface BZRNetworkManager : AFHTTPSessionManager


- (void)getClientCredentialsOnCompletion:(SuccessTokenBlock)completion;
//sign up/in
- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessTokenBlock)result;
- (void)signUpWithUserFirstName:(NSString *)firstName andUserLastName:(NSString *)lastName andEmail:(NSString *)email withResult:(SuccessBlock)result;

- (void)authorizeWithFacebookWithResult:(UserProfileBlock)result;

//post image
- (void)postImage:(UIImage *)image withID:(NSInteger)ID result:(ImageUserBlock)result;

@end
