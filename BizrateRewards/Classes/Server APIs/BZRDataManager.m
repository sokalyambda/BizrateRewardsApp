//
//  BZRDataManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRSessionTypeApplication,
    BZRSessionTypeUser
} BZRSessionType;

#import "BZRDataManager.h"

#import "BZRKeychainHandler.h"

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
    if (self.network.reachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
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
        _network = [BZRNetworkManager new];
        _storage = [BZRStorageManager sharedStorage];
    }
    return self;
}

#pragma mark - Requests

#pragma mark - Auth

- (void)getClientCredentialsOnSuccess:(SuccessBlock)completion
{
    WEAK_SELF;
    if (![self isSessionValidWithType:BZRSessionTypeApplication]) {
        [self.network getClientCredentialsOnCompletion:^(BOOL success, BZRApplicationToken *token, NSError *error) {
            if (success) {
                weakSelf.storage.applicationToken = token;
            }
            completion(success, error, 0);
        }];
    } else {
        completion (YES, nil, 0);
    }
}

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result
{
    self.network.requestSerializer = self.httpRequestSerializer;
    WEAK_SELF;
    [self.network signInWithUserName:userName password:password withResult:^(BOOL success, BZRUserToken *token, NSError *error, NSInteger responseStatusCode) {
        if (success) {
            weakSelf.storage.userToken = token;
        }
        result(success, error, responseStatusCode);
    }];
}

- (void)signUpWithUserFirstName:(NSString *)firstName
                andUserLastName:(NSString *)lastName
                       andEmail:(NSString *)email
                    andPassword:(NSString *)password
                 andDateOfBirth:(NSString *)birthDate
                      andGender:(NSString *)gender
                     withResult:(SuccessBlock)result
{
    self.network.requestSerializer = self.jsonRequestSerializer;
    [self addAuthHeaderWithToken:self.storage.applicationToken];
    
    WEAK_SELF;
    [self.network signUpWithUserFirstName:firstName
                          andUserLastName:lastName
                                 andEmail:email
                              andPassword:password
                           andDateOfBirth:birthDate
                                andGender:gender
                               withResult:^(BOOL success, BZRUserToken *userToken, NSError *error, NSInteger responseStatusCode) {
        if (success) {
            weakSelf.storage.userToken = userToken;
        }
        result(success, error, responseStatusCode);
    }];
}

- (void)authorizeWithFacebookWithResult:(SuccessBlock)result
{
    WEAK_SELF;
    [self.network authorizeWithFacebookWithResult:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        weakSelf.storage.currentProfile = userProfile;
        result(success, error, 0);
    }];
}

- (void)signOutOnSuccess:(SuccessBlock)result
{
    
    [BZRStorageManager sharedStorage].currentProfile = nil;
    [BZRStorageManager sharedStorage].applicationToken = nil;
    [BZRStorageManager sharedStorage].userToken = nil;
    
//    [BZRKeychainHandler resetKeychain];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RememberMeKey];
    
    result(YES, nil, 0);
}

#pragma mark - GET

#pragma mark Current User

- (void)getCurrentUserWithCompletion:(SuccessBlock)completion
{
    self.network.requestSerializer = self.httpRequestSerializer;
    [self addAuthHeaderWithToken:self.storage.userToken];
    
    WEAK_SELF;
    [self.network getCurrentUserWithCompletion:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        if (success) {
            weakSelf.storage.currentProfile = userProfile;
        }
        completion(success, error, 0);
    }];
}

#pragma mark Survey

- (void)getSurveysListWithResult:(SurveysBlock)result
{
    [self addAuthHeaderWithToken:self.storage.userToken];
    self.network.requestSerializer = self.httpRequestSerializer;
    
    [self.network getSurveysListWithResult:^(BOOL success, NSArray *surveysList, NSError *error) {
        result (success, surveysList, error);
    }];
}

#pragma mark - PUT update user

- (void)updateCurrentUserWithFirstName:(NSString *)firstName
                           andLastName:(NSString *)lastName
                        andDateOfBirth:(NSString *)dateOfBirth
                             andGender:(NSString *)gender
                        withCompletion:(SuccessBlock)completion
{
    self.network.requestSerializer = self.jsonRequestSerializer;
    [self addAuthHeaderWithToken:self.storage.userToken];
    
    WEAK_SELF;
    [self.network updateCurrentUserWithFirstName:firstName
                                     andLastName:lastName
                                  andDateOfBirth:dateOfBirth
                                       andGender:gender
                                  withCompletion:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
                                      if (success) {
                                          weakSelf.storage.currentProfile = userProfile;
                                      }
                                      completion(success, error, 0);
    }];
}

#pragma mark - POST send device token

- (void)sendDeviceAPNSTokenAndDeviceIdentifierWithResult:(SuccessBlock)result
{
    NSString *deviceToken = self.storage.deviceToken;
    NSString *deviceIdentifier = self.storage.deviceUDID;
    
    if (deviceToken.length && deviceIdentifier.length) {
        [self.network sendDeviceAPNSToken:deviceToken andDeviceIdentifier:deviceIdentifier withResult:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
            result(success, error, responseStatusCode);
        }];
    } else {
        result(NO, nil, 0);
    }
}

#pragma mark - Private methods

- (void)addAuthHeaderWithToken:(BZRApplicationToken *)token
{
    [self.jsonRequestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
    [self.httpRequestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
}

- (BOOL)isSessionValidWithType:(BZRSessionType)type
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
    
    if (accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending)) {
        return YES;
    }
    return NO;
}

@end
