//
//  BZRNetworkManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkManager.h"

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

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super initWithBaseURL:baseURL];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/schema+json", @"application/json", @"application/x-www-form-urlencoded", nil]];

        //reachability
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        _reachabilityStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        
        WEAK_SELF;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachabilityStatus = status;
        }];
    }
    
    return self;
}

#pragma mark - Authorization

- (void)renewSessionTokenWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self POST:AuthActionKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getClientCredentialsWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self POST:AuthActionKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                                               success(responseObject);
                                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                               failure(error);
                                           }];
}

- (void)signInWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self POST:AuthActionKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)signUpWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    WEAK_SELF;
    [weakSelf POST:CreateUserKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)authorizeWithFacebookOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    WEAK_SELF;
    [self tryLoginWithFacebookOnSuccess:^(BOOL isSuccess, NSDictionary *facebookProfile, NSString *faceBookAccessToken, NSError *error) {
        if (success) {
            [weakSelf POST:@"user/facebook" parameters:@{@"fb_access_token" : faceBookAccessToken} success:^(NSURLSessionDataTask *task, id responseObject) {
                
//                BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
//                
//                NSURL *userImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", [facebookProfile valueForKey:@"id"]]];
//                
//                userProfile.avatarURL = userImageURL;
//                
//                result(YES, userProfile, nil);
                
                success(responseObject);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                result(NO, nil, error);
                failure(error);
            }];
        } else {
            failure(error);
//            result(NO, nil, error);
        }
    }];
}

- (void)tryLoginWithFacebookOnSuccess:(FacebookProfileBlock)completion
{
    BOOL isFBinstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    if (isFBinstalled) {
        self.loginManager.loginBehavior = FBSDKLoginBehaviorNative;
    } else {
        self.loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    }
    
    [self.loginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        BOOL success = YES;
        if (error) {
            success = NO;
            completion(success, nil, nil, error);
        } else if (result.isCancelled) {
            success = NO;
            completion(success, nil, nil, error);
        } else {
            //success = YES;

            if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"]) {
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

#pragma mark - GET
#pragma mark - Current User

- (void)getCurrentUserOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self GET:UserMeKey parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

#pragma mark - Surveys

- (void)getSurveysListOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;
{
    [self GET:EligibleSurveysKey parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

#pragma mark - PUT 

#pragma mark Update user

- (void)updateCurrentUserWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self PUT:UserMeKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

#pragma mark - POST 

#pragma mark Send device token

- (void)sendDeviceCredentialsWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self POST:DeviceKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

#pragma mark Image

- (void)postImage:(UIImage *)image withID:(NSInteger)ID onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"userId" : @(ID)};
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [self POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
