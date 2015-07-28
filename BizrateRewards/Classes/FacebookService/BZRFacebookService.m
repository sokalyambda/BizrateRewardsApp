//
//  BZRFacebookService.m
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFacebookService.h"

static NSString *const kPublicProfile = @"public_profile";
static NSString *const kEmail = @"email";
static NSString *const kFields = @"fields";

static NSString *const kFBAppId = @"851500644887516";
static NSString *const kFBAppSecret = @"530fa94f7370fc20a54cc392fbd83cf2";

@implementation BZRFacebookService

#pragma mark - Public Methods

+ (void)authorizeWithFacebookOnSuccess:(FacebookAuthSuccessBlock)success onFailure:(FacebookAuthFailureBlock)failure
{
    BOOL isFBinstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    if (isFBinstalled) {
        loginManager.loginBehavior = FBSDKLoginBehaviorNative;
    } else {
        loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    }
    
    [loginManager logInWithReadPermissions:@[kPublicProfile, kEmail] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            failure(error, result.isCancelled);
        } else if (result.isCancelled) {
            failure(error, result.isCancelled);
        } else {
            if ([result.grantedPermissions containsObject:kEmail] && [result.grantedPermissions containsObject:kPublicProfile]) {
                
                //store fb auth data
                [self storeFacebookAuthData];
                
                success(YES);
            }
        }
    }];
}

+ (void)getFacebookUserProfileOnSuccess:(FacebookProfileSuccessBlock)success onFailure:(FacebookProfileFailureBlock)failure
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, name, email" forKey:kFields];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id response, NSError *error) {
        if (error) {
            failure(error);
        } else {
            //            NSDictionary *user = (NSDictionary *)response;
            //            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"facebook_id":[user valueForKey:@"id"], @"first_name":[user valueForKey:@"first_name"], @"last_name":[user valueForKey:@"last_name"]}];
            success(response);
        }
    }];
}

+ (void)getTestFacebookUserProfileWithId:(NSString *)userId andWithTokenString:(NSString *)tokenString OnSuccess:(FacebookProfileSuccessBlock)success onFailure:(FacebookProfileFailureBlock)failure
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, name, email" forKey:kFields];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@", userId] parameters:parameters tokenString:tokenString version:nil HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id response, NSError *error) {
        if (error) {
            failure(error);
        } else {
            //            NSDictionary *user = (NSDictionary *)response;
            //            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"facebook_id":[user valueForKey:@"id"], @"first_name":[user valueForKey:@"first_name"], @"last_name":[user valueForKey:@"last_name"]}];
            success(response);
        }
    }];
}

+ (void)authorizeTestFacebookUserOnSuccess:(void(^)(FBSDKAccessToken *token))success onFailure:(FacebookAuthFailureBlock)failure
{
    [[FBSDKTestUsersManager sharedInstanceForAppID:kFBAppId appSecret:kFBAppSecret] requestTestAccountTokensWithArraysOfPermissions:@[[NSSet set], [NSSet set]] createIfNotFound:NO completionHandler:^(NSArray *tokens, NSError *error) {
        NSLog(@"tokens %@", tokens);
        success((FBSDKAccessToken *)[tokens firstObject]);
    }];
    
    
//    [[FBSDKTestUsersManager sharedInstanceForAppID:kFBAppId appSecret:kFBAppSecret] addTestAccountWithPermissions:[NSSet setWithObjects:@"email", nil] completionHandler:^(NSArray *tokens, NSError *error) {
//        NSLog(@"tokens %@", tokens);
//        success((FBSDKAccessToken *)[tokens firstObject]);
//    }];
}

+ (void)logoutFromFacebook
{
    [self clearFacebookAuthData];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

+ (void)setLoginSuccess:(BOOL)success
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:success forKey:FBLoginSuccess];
    [defaults synchronize];
}

+ (BOOL)isFacebookSessionValid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *fbTokenExpidaionDate = [defaults objectForKey:FBAccessTokenExpirationDate];
    
    if ([self isLoginedWithFacebook] && ([[NSDate date] compare:fbTokenExpidaionDate] == NSOrderedAscending)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Private Methods

+ (void)storeFacebookAuthData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:FBAccessToken];
    [defaults setObject:[FBSDKAccessToken currentAccessToken].expirationDate forKey:FBAccessTokenExpirationDate];
    [defaults synchronize];
}

+ (void)clearFacebookAuthData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:FBAccessToken];
    [defaults removeObjectForKey:FBAccessTokenExpirationDate];
    [self setLoginSuccess:NO];
    [defaults synchronize];
}

+ (BOOL)isLoginedWithFacebook
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:FBAccessToken] && [defaults objectForKey:FBAccessTokenExpirationDate] && [defaults boolForKey:FBLoginSuccess];
}

@end
