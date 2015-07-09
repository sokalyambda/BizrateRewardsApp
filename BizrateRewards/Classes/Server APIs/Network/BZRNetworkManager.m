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
        
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/schema+json", @"application/json", @"application/x-www-form-urlencoded", nil]];
        
        //reachability
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        self.reachabilityStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        
        WEAK_SELF;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachabilityStatus = status;
        }];
    }
    
    return self;
}

#pragma mark - SignIn

- (void)getClientCredentialsOnCompletion:(SuccessApplicationTokenBlock)completion
{
    [self POST:@"oauth/token" parameters:@{@"grant_type" : GrantTypeClientCredentials,
                                           
                                           @"client_id" : kClientIdKey,
                                           
                                           @"client_secret" : kClientSecretKey
                                           } success:^(NSURLSessionDataTask *task, id responseObject) {
                                               
                                               BZRApplicationToken *token = [[BZRApplicationToken alloc] initWithServerResponse:responseObject];
                                               
                                               completion(YES, token, nil);
                                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                               completion(NO, nil, error);
                                           }];
}

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessUserTokenBlock)result
{
    NSDictionary *parameter = @{@"username" : userName,
                                @"password" : password,
                                @"grant_type" : GrantTypePassword,
                                @"client_id" : kClientIdKey,
                                @"client_secret" : kClientSecretKey};
    [self POST:@"oauth/token" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        
        BZRUserToken *token = [[BZRUserToken alloc] initWithServerResponse:responseObject];
        
        return result(YES, token, nil, response.statusCode);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        return result(NO, nil, error, response.statusCode);
    }];
}

- (void)signUpWithUserFirstName:(NSString *)firstName andUserLastName:(NSString *)lastName andEmail:(NSString *)email withResult:(SuccessBlock)result
{
    NSDictionary *parameters = @{@"firstname" : firstName,
                                @"lastName" : lastName,
                                @"email" : email};
    
    WEAK_SELF;
    [weakSelf POST:@"user" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        return result(YES, nil, 0);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return result(NO, error, 0);
    }];
}

- (void)authorizeWithFacebookWithResult:(UserProfileBlock)result
{
    WEAK_SELF;
    [self tryLoginWithFacebookOnSuccess:^(BOOL success, NSDictionary *facebookProfile, NSString *faceBookAccessToken, NSError *error) {
        if (success) {
            [weakSelf POST:@"user/facebook" parameters:@{@"fb_access_token" : faceBookAccessToken} success:^(NSURLSessionDataTask *task, id responseObject) {
                
                BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
                
                NSURL *userImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", [facebookProfile valueForKey:@"id"]]];
                
                userProfile.avatarURL = userImageURL;
                
                result(YES, userProfile, nil);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                result(NO, nil, error);
            }];
        } else {
            result(NO, nil, error);
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

//get user
- (void)getCurrentUserWithCompletion:(UserProfileBlock)completion
{
    [self GET:@"user/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        BZRUserProfile *currentUserProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        completion(YES, currentUserProfile, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, nil, error);
    }];
}

//send device token
- (void)sendDeviceAPNSToken:(NSString *)token andDeviceIdentifier:(NSString *)udid withResult:(SuccessBlock)result
{
    NSDictionary *parameters = @{@"device_id" : udid, @"notification_token" : token};
    
    [self POST:@"user/device" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        result(YES, nil, 0);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO, error, 0);
    }];
}

- (void)getSurveyWithResult:(SurveyBlock)result
{
    [self POST:@"user/survey" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        BZRSurvey *survey = [[BZRSurvey alloc] initWithServerResponse:responseObject];
        result(YES, survey, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        result(NO, nil, error);
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
