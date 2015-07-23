//
//  BZRNetworkManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkManager.h"

@interface BZRNetworkManager ()

@end

@implementation BZRNetworkManager

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

- (void)authorizeWithFacebookWithParameters:(NSDictionary *)parameters onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self POST:UserFacebook parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
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
