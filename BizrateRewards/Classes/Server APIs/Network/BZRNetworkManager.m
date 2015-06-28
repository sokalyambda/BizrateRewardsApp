//
//  BZRNetworkManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRNetworkManager.h"
#import "BZRStorageManager.h"

static NSString *const kBaseURLString = @"https://api.bizraterewards.com/v1/";

static NSString *const kClientIdKey = @"92196543-9462-4b90-915a-738c9b4b558f";

static NSString *const kClientSecretKey = @"8a9da763-9503-4093-82c2-6b22b8eb9a12";

@interface BZRNetworkManager ()

@property (strong, nonatomic) FBSDKLoginManager *loginManager;

@end

@implementation BZRNetworkManager

#pragma mark - Accessors

- (FBSDKLoginManager *)loginManager
{
    if (!_loginManager) {
        _loginManager = [[FBSDKLoginManager alloc] init];
    }
    return _loginManager;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    NSURL *baseURL = [NSURL URLWithString:kBaseURLString];
    self = [super initWithBaseURL:baseURL];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

#pragma mark - SignIn

- (void)getClientCredentialsOnCompletion:(SuccessTokenBlock)completion
{
    [self POST:@"oauth/token" parameters:@{@"grant_type" : GrantTypeClientCredentials,
                                           
                                           @"client_id" : kClientIdKey,
                                           
                                           @"client_secret" : kClientSecretKey
                                           } success:^(NSURLSessionDataTask *task, id responseObject) {
                                               
                                               BZRToken *token = [[BZRToken alloc] initWithServerResponse:responseObject];
                                               completion(YES, token, nil);
                                               
                                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                               NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                                               NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                                               NSLog(@"error %@", errorString);
                                               completion(NO, nil, error);
                                           }];
}

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessTokenBlock)result
{

    NSDictionary *parameter = @{@"username" : @"john.doe@mailinator.com",
                                @"password" : @"12345",
                                @"grant_type" : GrantTypePassword,
                                @"client_id" : kClientIdKey,
                                @"client_secret" : kClientSecretKey};
    [self POST:@"oauth/token" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        BZRToken *token = [[BZRToken alloc] initWithServerResponse:responseObject];
        
        return result(YES, token, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return result(NO, nil, error);
    }];
}

- (void)signUpWithUserFirstName:(NSString *)firstName andUserLastName:(NSString *)lastName andEmail:(NSString *)email withResult:(SuccessBlock)result
{
//    NSDictionary *parameter = @{@"firstname" : firstName,
//                                @"lastName" : lastName,
//                                @"email" : email};
    
    WEAK_SELF;
    [weakSelf POST:@"user" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        return result(YES, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return result(NO, error);
    }];
}

- (void)authorizeWithFacebookWithResult:(UserProfileBlock)result
{
    WEAK_SELF;
    [self tryLoginWithFacebookOnSuccess:^(BOOL success, NSDictionary *facebookProfile, NSString *faceBookAccessToken, NSError *error) {
        [weakSelf POST:@"user/facebook" parameters:@{@"fb_access_token" : faceBookAccessToken} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
            
            NSURL *userImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", [facebookProfile valueForKey:@"id"]]];
            
            userProfile.avatarURL = userImageURL;
            
            return result(YES, userProfile, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            return result(NO, nil, error);
        }];
    }];
}

- (void)getCurrentUserWithCompletion:(UserProfileBlock)completion
{
    [self GET:@"user/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        BZRUserProfile *currentUserProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        completion(YES, currentUserProfile, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, nil, error);
    }];
}

- (void)tryLoginWithFacebookOnSuccess:(FacebookProfileBlock)completion
{
    WEAK_SELF;
    [self.loginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *resultBlock, NSError *error) {
        if (error) {
            // Process error
        } else if (resultBlock.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([resultBlock.grantedPermissions containsObject:@"email"] && [resultBlock.grantedPermissions containsObject:@"public_profile"]) {
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id response, NSError *error) {
                    if (error) {
                        completion(NO, nil, nil, error);
                        //Error
                    } else {
                        NSDictionary *user = (NSDictionary *)response;
//                        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"facebook_id":[user valueForKey:@"id"], @"first_name":[user valueForKey:@"first_name"], @"last_name":[user valueForKey:@"last_name"]}];
                        
                        NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                        completion(YES, user, fbAccessToken, nil);

                    }
                }];
            }
        }
    }];
}

//post image

- (void)postImage:(UIImage *)image withID:(NSInteger)ID result:(ImageUserBlock)result
{
    NSDictionary *parameters = @{@"userId" : @(ID)};
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [self POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        return result(YES, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return result(NO, nil);
    }];
}


@end
