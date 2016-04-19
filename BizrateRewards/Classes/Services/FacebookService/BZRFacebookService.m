//
//  BZRFacebookService.m
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFacebookService.h"
#import "BZRFacebookProfileService.h"

#import "BZRFacebookProfile.h"
#import "BZRFacebookAccessToken.h"

#import "BZRCoreDataStorage.h"

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
+ (void)authorizeWithFacebookFromController:(UIViewController *)fromController
                                  onSuccess:(FacebookAuthSuccessBlock)success
                                  onFailure:(FacebookAuthFailureBlock)failure
{
    [[self facebookLoginManager] logInWithReadPermissions:@[kPublicProfile, kEmail] fromViewController:fromController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error && failure) {
            failure(error, result.isCancelled);
        } else if (result.isCancelled && failure) {
            failure(error, result.isCancelled);
        } else {
            if ([result.grantedPermissions containsObject:kEmail] && [result.grantedPermissions containsObject:kPublicProfile]) {
                if (success) {
                    success(YES);
                }
            } else {
                if (failure) {
                    failure(error, result.isCancelled);
                }
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
    [parameters setValue:@"picture.type(large), id, name, first_name, last_name, email, gender" forKey:kFields];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters HTTPMethod:@"GET"];
    
    WEAK_SELF;
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id response, NSError *error) {
        if (error && failure) {
            failure(error);
        } else {
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)response];
            
            BZRFacebookProfile *facebookProfile = [BZRFacebookProfileService facebookProfileFromServerResponse:userProfile];
            //store fb auth data
            [weakSelf storeFacebookAuthData];
            
            if (success) {
                success(facebookProfile);
            }
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
    BZRFacebookProfile *currentProfile = [BZRCoreDataStorage getCurrentFacebookProfile];
    if (currentProfile) {
        currentProfile.isLogined = @(success);
        [BZRCoreDataStorage saveContext];
    }
}

/**
 *  Validate FB session
 *
 *  @return It will be true if user has logined and token's expiration date doesn't come
 */
+ (BOOL)isFacebookSessionValid
{
    NSDate *fbTokenExpidaionDate = [BZRCoreDataStorage getCurrentFacebookProfile].facebookAccessToken.expirationDate;
    
    if ([self isLoginedWithFacebook] && ([[NSDate date] compare:fbTokenExpidaionDate] == NSOrderedAscending)) {
        return YES;
    } else {
        //if session isn't valid - remove FB profile from defaults (if exists)
        if ([BZRCoreDataStorage getCurrentFacebookProfile]) {
            [BZRCoreDataStorage removeFacebookProfile:[BZRCoreDataStorage getCurrentFacebookProfile]];
        }
        return NO;
    }
}


#pragma mark - Private Methods

/**
 *  Store FB authorization data in Core Data
 */
+ (void)storeFacebookAuthData
{
    BZRFacebookProfile *profile = [BZRCoreDataStorage getCurrentFacebookProfile];
    profile.facebookAccessToken = [BZRCoreDataStorage addFacebookAccessTokenWithTokenValue:[FBSDKAccessToken currentAccessToken].tokenString andExpirationDate:[FBSDKAccessToken currentAccessToken].expirationDate];
}

/**
 *  Remove facebook data (access token and expiration date from Core Data)
 */
+ (void)clearFacebookAuthData
{
    if ([BZRCoreDataStorage getCurrentFacebookProfile]) {
        [BZRCoreDataStorage removeFacebookProfile:[BZRCoreDataStorage getCurrentFacebookProfile]];
    }
    [self setLoginSuccess:NO];
}

/**
 *  Check whether login with facebook was succeded
 *
 *  @return Logined or No
 */
+ (BOOL)isLoginedWithFacebook
{
    BZRFacebookProfile *currentProfile = [BZRCoreDataStorage getCurrentFacebookProfile];
    BZRFacebookAccessToken *token = currentProfile.facebookAccessToken;
    return token.tokenValue && token.expirationDate && currentProfile.isLogined;
}

@end
