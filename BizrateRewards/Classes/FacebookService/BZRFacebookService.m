//
//  BZRFacebookService.m
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFacebookService.h"

#import "BZRStorageManager.h"

static NSString *const kPublicProfile = @"public_profile";
static NSString *const kEmail = @"email";
static NSString *const kFields = @"fields";

static NSString *const kFBAppId = @"851500644887516";
static NSString *const kFBAppSecret = @"530fa94f7370fc20a54cc392fbd83cf2";

@implementation BZRFacebookService

/**
 *  Create the static instance of FBSDKLoginManager to avoid error, when it come to nil
 *
 *  @return Static FB login manager
 */
+ (FBSDKLoginManager *)facebookLoginManager
{
    static FBSDKLoginManager *loginManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL isFBinstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
        
        loginManager = [[FBSDKLoginManager alloc] init];
        
        if (isFBinstalled) {
            loginManager.loginBehavior = FBSDKLoginBehaviorNative;
        } else {
            loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
        }
    });
    return loginManager;
}

#pragma mark - Public Methods

/**
 *  Authorize with facebook account (via FB iOS application or webView)
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (void)authorizeWithFacebookOnSuccess:(FacebookAuthSuccessBlock)success onFailure:(FacebookAuthFailureBlock)failure
{
    [[self facebookLoginManager] logInWithReadPermissions:@[kPublicProfile, kEmail] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            failure(error, result.isCancelled);
        } else if (result.isCancelled) {
            failure(error, result.isCancelled);
        } else {
            if ([result.grantedPermissions containsObject:kEmail] && [result.grantedPermissions containsObject:kPublicProfile]) {
                //store fb auth data
                [self storeFacebookAuthData];
                success(YES);
            } else {
                failure(error, result.isCancelled);
            }
        }
    }];
}

/**
 *  Get current authorized facebook profile
 *
 *  @param success Success Block with FB profile dictionary
 *  @param failure Failure Block with an error
 */
+ (void)getFacebookUserProfileOnSuccess:(FacebookProfileSuccessBlock)success onFailure:(FacebookProfileFailureBlock)failure
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"picture.type(large) ,id, name, email" forKey:kFields];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id response, NSError *error) {
        if (error) {
            failure(error);
        } else {
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)response];
            
            BZRFacebookProfile *facebookProfile = [[BZRFacebookProfile alloc] initWithServerResponse:userProfile];
            [facebookProfile setFacebookProfileToDefaultsForKey:FBCurrentProfile];
            
            success(facebookProfile);
        }
    }];
}

/**
 *  Logout from facebook account
 */
+ (void)logoutFromFacebook
{
    [self clearFacebookAuthData];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

/**
 *  Set success login key to user defaults
 *
 *  @param success BOOL value which will be set to user defaults
 */
+ (void)setLoginSuccess:(BOOL)success
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:success forKey:FBLoginSuccess];
    [defaults synchronize];
}

/**
 *  Validate FB session
 *
 *  @return It will be true if user has logined and token's expiration date doesn't come
 */
+ (BOOL)isFacebookSessionValid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *fbTokenExpidaionDate = [defaults objectForKey:FBAccessTokenExpirationDate];
    
    if ([self isLoginedWithFacebook] && ([[NSDate date] compare:fbTokenExpidaionDate] == NSOrderedAscending)) {
        return YES;
    } else {
        //if session isn't valid - remove FB profile from defaults (if exists)
        if ([defaults objectForKey:FBCurrentProfile]) {
            [BZRStorageManager sharedStorage].facebookProfile = nil;
            [defaults removeObjectForKey:FBCurrentProfile];
            [defaults synchronize];
        }
        return NO;
    }
}

#pragma mark - Private Methods

/**
 *  Store FB authorization data in user defaults
 */
+ (void)storeFacebookAuthData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:FBAccessToken];
    [defaults setObject:[FBSDKAccessToken currentAccessToken].expirationDate forKey:FBAccessTokenExpirationDate];
    [defaults synchronize];
}

/**
 *  Remove facebook data (access token and expiration date from User Defaults
 */
+ (void)clearFacebookAuthData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:FBAccessToken];
    [defaults removeObjectForKey:FBAccessTokenExpirationDate];
    
    [BZRStorageManager sharedStorage].facebookProfile = nil;
    [defaults removeObjectForKey:FBCurrentProfile];
    
    [self setLoginSuccess:NO];
    
    [defaults synchronize];
}

/**
 *  Check whether login with facebook was succeded
 *
 *  @return Logined or No
 */
+ (BOOL)isLoginedWithFacebook
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:FBAccessToken] && [defaults objectForKey:FBAccessTokenExpirationDate] && [defaults boolForKey:FBLoginSuccess];
}

@end
