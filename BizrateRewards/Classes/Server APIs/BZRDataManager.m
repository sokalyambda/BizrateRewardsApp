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

@interface BZRDataManager ()

@property (strong, nonatomic) BZRNetworkManager *network;
@property (strong, nonatomic) BZRStorageManager *storage;

@end

@implementation BZRDataManager

#pragma mark - Accessors

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
    WEAK_SELF;
    if (![self isSessionValidWithType:BZRSessionTypeUser]) {
        [self.network signInWithUserName:userName password:password withResult:^(BOOL success, BZRUserToken *token, NSError *error, NSInteger responseStatusCode) {
            if (success) {
                weakSelf.storage.userToken = token;
            }
            result(success, error, responseStatusCode);
        }];
    } else {
        result(YES, nil, 0);
    }
}

- (void)signUpWithUserFirstName:(NSString *)firstName andUserLastName:(NSString *)lastName andEmail:(NSString *)email withResult:(SuccessBlock)result
{
    [self addAuthHeaderWithToken:self.storage.applicationToken];
    [self.network signUpWithUserFirstName:firstName andUserLastName:lastName andEmail:email withResult:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
        return result(success, error, responseStatusCode);
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

//Get User
- (void)getCurrentUserWithCompletion:(SuccessBlock)completion
{
    [self addAuthHeaderWithToken:self.storage.userToken];
    WEAK_SELF;
    [self.network getCurrentUserWithCompletion:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        if (success) {
            weakSelf.storage.currentProfile = userProfile;
        }
        completion(success, error, 0);
    }];
}

//send device token
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

//getSurvey
- (void)getSurveyWithResult:(SurveyBlock)result
{
    [self addAuthHeaderWithToken:self.storage.applicationToken];
    [self.network getSurveyWithResult:^(BOOL success, BZRSurvey *survey, NSError *error) {
        result(success, survey, error);
    }];
}

#pragma mark - Private methods

- (void)addAuthHeaderWithToken:(BZRApplicationToken *)token
{
    [self.network.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
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
