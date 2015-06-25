//
//  BZRNetworkManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRNetworkManager.h"
#import "BZRStorageManager.h"

NSString *const baseURLString = @"https://api.bizraterewards.com/v1";

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
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    self = [super initWithBaseURL:baseURL];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

#pragma mark - SignIn

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(UserProfileBlock)result
{
    NSDictionary *parameter = @{@"username" : userName,
                                @"password" : password};
    [self POST:@"/oauth2/token" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        return result(YES, userProfile, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return result(NO, nil, error);
    }];
}

- (void)signInWithFacebookWithResult:(UserProfileBlock)result
{
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
                        //Error
                        result(NO, nil, error);
                    } else {
                        NSDictionary *user = (NSDictionary *)response;
                        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"facebook_id":[user valueForKey:@"id"], @"first_name":[user valueForKey:@"first_name"], @"last_name":[user valueForKey:@"last_name"]}];
                        
                        if ([BZRStorageManager sharedStorage].deviceToken) {
                            [parameters setValue:[BZRStorageManager sharedStorage].deviceToken forKey:@"deviceToken"];
                        }
#warning for testing only!
                        BZRUserProfile *userProfile = [[BZRUserProfile alloc] init];
                        
                        NSURL *userImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", [user valueForKey:@"id"]]];
                        
                        userProfile.avatarURL = userImageURL;
                        return result(YES, userProfile, nil);
                    }
                }];
            }
        }
    }];
}

- (void)signUpWithUserName:(NSString *)userName password:(NSString *)password withResult:(UserProfileBlock)result
{
    NSDictionary *parameter = @{@"" : userName,
                                @"" : password};
    [self POST:@"" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        return result(YES, userProfile, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return result(NO, nil, error);
    }];
}

- (void)signUpWithFacebookWithResult:(UserProfileBlock)result
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
                        //Error
                    } else {
                        NSDictionary *user = (NSDictionary *)response;
                        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"facebook_id":[user valueForKey:@"id"], @"first_name":[user valueForKey:@"first_name"], @"last_name":[user valueForKey:@"last_name"]}];
                        
                        if ([BZRStorageManager sharedStorage].deviceToken) {
                            [parameters setValue:[BZRStorageManager sharedStorage].deviceToken forKey:@"deviceToken"];
                        }
                        
                        [self POST:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                            BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
                            
                            NSURL *userImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", [user valueForKey:@"id"]]];
                            
                            userProfile.avatarURL = userImageURL;
                            /*
                            SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc] init];
                            
                            [downloader downloadImageWithURL:userImageURL options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                [weakSelf postImage:image withID:[[user valueForKey:@"id"] integerValue] result:^(BOOL success, UIImage *image) {
                                    
                                }];
                            }];
                             */
                            
                            return result(YES, userProfile, nil);
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            return result(NO, nil, error);
                        }];
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
