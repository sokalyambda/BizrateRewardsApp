//
//  BZRDataManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRDataManager.h"

#import "BZRKeychainHandler.h"

static NSString *const kBaseURLString = @"https://api.bizraterewards.com/v1/";

static NSString *const kGrantTypePassword           = @"password";
static NSString *const kGrantTypeClientCredentials  = @"client_credentials";
static NSString *const kGrantTypeRefreshToken       = @"refresh_token";

static NSString *const kClientIdKey                 = @"92196543-9462-4b90-915a-738c9b4b558f";
static NSString *const kClientSecretKey             = @"8a9da763-9503-4093-82c2-6b22b8eb9a12";

//parameters keys

static NSString *const kGrantType           = @"grant_type";
static NSString *const kClientId            = @"client_id";
static NSString *const kClientSecret        = @"client_secret";
static NSString *const kRefreshToken        = @"refresh_token";

static NSString *const kUsername            = @"username";
static NSString *const kPassword            = @"password";

static NSString *const kFirstName           = @"firstname";
static NSString *const kLastName            = @"lastname";
static NSString *const kEmail               = @"email";
static NSString *const kGender              = @"gender";
static NSString *const kDateOfBirth         = @"dob";

static NSString *const kIsTestUser          = @"is_test_user";

static NSString *const kDeviceId            = @"device_id";
static NSString *const kNotificationToken   = @"notification_token";


@interface BZRDataManager ()

@property (strong, nonatomic) BZRNetworkManager *network;
@property (strong, nonatomic) BZRStorageManager *storage;

@property (strong, nonatomic) AFJSONRequestSerializer *jsonRequestSerializer;
@property (strong, nonatomic) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation BZRDataManager

#pragma mark - Accessors

- (AFJSONRequestSerializer *)jsonRequestSerializer
{
    if (!_jsonRequestSerializer) {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _jsonRequestSerializer;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _httpRequestSerializer;
}

- (BOOL)isReachable
{
    if (!self.network.reachabilityManager.isReachable) {
        return NO;
    }
    return YES;
}

#pragma mark - Lifecycle

+ (BZRDataManager *)sharedInstance
{
    static BZRDataManager *singletonObject = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
        
    });
    return singletonObject;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _network = [[BZRNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        _storage = [BZRStorageManager sharedStorage];
    }
    return self;
}

#pragma mark - Requests

#pragma mark - Auth

- (void)renewSessionTokenOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    NSString *refreshToken = self.storage.userToken.refreshToken;
    
    NSDictionary *parameters = @{kGrantType : kGrantTypeRefreshToken,
                                 kClientId : kClientIdKey,
                                 kClientSecret : kClientSecretKey,
                                 kRefreshToken : refreshToken};
    
    [self.network renewSessionTokenWithParameters:parameters onSuccess:^(id responseObject) {
        BZRUserToken *token = [[BZRUserToken alloc] initWithServerResponse:responseObject];
        [BZRStorageManager sharedStorage].userToken = token;
        success(responseObject);
        
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getClientCredentialsOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    NSDictionary *parameters = @{kGrantType: kGrantTypeClientCredentials,
                                 kClientId: kClientIdKey,
                                 kClientSecret: kClientSecretKey
                                 };
    
    [self.network getClientCredentialsWithParameters:parameters onSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    NSDictionary *parameters = @{kUsername : userName,
                                kPassword : password,
                                kGrantType : kGrantTypePassword,
                                kClientId : kClientIdKey,
                                kClientSecret : kClientSecretKey};
    
    self.network.requestSerializer = self.httpRequestSerializer;
    
    [self.network signInWithParameters:parameters onSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)signUpWithUserFirstName:(NSString *)firstName
                andUserLastName:(NSString *)lastName
                       andEmail:(NSString *)email
                    andPassword:(NSString *)password
                 andDateOfBirth:(NSString *)birthDate
                      andGender:(NSString *)gender
                      onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    self.network.requestSerializer = self.jsonRequestSerializer;
    [self addAuthHeaderWithToken:self.storage.applicationToken];
    
    NSDictionary *parameters = @{kFirstName: firstName,
                                 kLastName: lastName,
                                 kEmail: email,
                                 kPassword: password,
                                 kGender: gender,
                                 kDateOfBirth: birthDate,
                                 kIsTestUser: @YES};
    
    [self.network signUpWithParameters:parameters onSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)authorizeWithFacebookOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self.network authorizeWithFacebookOnSuccess:^(id responseObject) {
        BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        
//        NSURL *userImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", [facebookProfile valueForKey:@"id"]]];
//        
//        userProfile.avatarURL = userImageURL;
        success(responseObject);

    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)signOutOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [BZRStorageManager sharedStorage].currentProfile = nil;
    [BZRStorageManager sharedStorage].applicationToken = nil;
    [BZRStorageManager sharedStorage].userToken = nil;
    
    [BZRKeychainHandler resetKeychain];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RememberMeKey];
    
    success(nil);
}

#pragma mark - GET

#pragma mark Current User

- (void)getCurrentUserOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    self.network.requestSerializer = self.httpRequestSerializer;
    [self addAuthHeaderWithToken:self.storage.userToken];
    
    [self.network getCurrentUserOnSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark Survey

- (void)getSurveysListOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self addAuthHeaderWithToken:self.storage.userToken];
    self.network.requestSerializer = self.httpRequestSerializer;

    [self.network getSurveysListOnSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - PUT update user

- (void)updateCurrentUserWithFirstName:(NSString *)firstName
                           andLastName:(NSString *)lastName
                        andDateOfBirth:(NSString *)dateOfBirth
                             andGender:(NSString *)gender
                             onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    self.network.requestSerializer = self.jsonRequestSerializer;
    [self addAuthHeaderWithToken:self.storage.userToken];
    
    NSDictionary *parameters = @{kFirstName: firstName,
                                 kLastName: lastName,
                                 kDateOfBirth: dateOfBirth,
                                 kGender: gender};
    
    [self.network updateCurrentUserWithParameters:parameters onSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - POST send device token

- (void)sendDeviceCredentialsOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    NSString *deviceToken = self.storage.deviceToken;
    NSString *deviceIdentifier = self.storage.deviceUDID;
    
    NSDictionary *parameters = @{kDeviceId : deviceIdentifier,
                                 kNotificationToken : deviceToken};
    
    [self.network sendDeviceCredentialsWithParameters:parameters onSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Public mehods

- (void)validateSessionWithType:(BZRSessionType)type withCompletion:(void(^)(BOOL success, NSError *error))completion
{
    NSString *accessToken;
    NSDate *tokenExpirationDate;
    
    switch (type) {
        case BZRSessionTypeApplication: {
            accessToken         = self.storage.applicationToken.accessToken;
            tokenExpirationDate = self.storage.applicationToken.expirationDate;
            break;
        }
        case BZRSessionTypeUser: {
            accessToken         = self.storage.userToken.accessToken;
            tokenExpirationDate = self.storage.userToken.expirationDate;
            break;
        }
        default:
            break;
    }
    
    if (!(accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending))) {
        if (type == BZRSessionTypeApplication) {
            completion(NO, nil);
        } else {
            [self renewSessionTokenOnSuccess:^(id responseObject) {
                completion(YES, nil);
            } onFailure:^(NSError *error) {
                completion(NO, error);
            }];
        }
    } else {
        completion(YES, nil);
    }
}

#pragma mark - Private methods

- (void)addAuthHeaderWithToken:(BZRApplicationToken *)token
{
    [self.jsonRequestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
    [self.httpRequestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
}

@end
