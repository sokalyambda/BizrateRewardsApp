//
//  BZRDataManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

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

- (void)getClientCredentialsOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    [self.network getClientCredentialsOnSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    self.network.requestSerializer = self.httpRequestSerializer;
    [self.network signInWithUserName:userName password:password onSuccess:^(id responseObject) {
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
    
    [self.network signUpWithUserFirstName:firstName andUserLastName:lastName andEmail:email andPassword:password andDateOfBirth:birthDate andGender:gender onSuccess:^(id responseObject) {
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
    
    [self.network updateCurrentUserWithFirstName:firstName andLastName:lastName andDateOfBirth:dateOfBirth andGender:gender onSuccess:^(id responseObject) {
        success(responseObject);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - POST send device token

- (void)sendDeviceAPNSTokenAndDeviceIdentifierOnSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    NSString *deviceToken = self.storage.deviceToken;
    NSString *deviceIdentifier = self.storage.deviceUDID;
    
    if (deviceToken.length && deviceIdentifier.length) {
        [self.network sendDeviceAPNSToken:deviceToken andDeviceIdentifier:deviceIdentifier onSuccess:^(id responseObject) {
            success(responseObject);
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } else {

    }
}

#pragma mark - Public mehods

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

#pragma mark - Private methods

- (void)addAuthHeaderWithToken:(BZRApplicationToken *)token
{
    [self.jsonRequestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
    [self.httpRequestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
}

@end
