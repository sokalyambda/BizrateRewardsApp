//
//  BZRDataManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRDataManager.h"

@interface BZRDataManager ()

@property (strong, nonatomic) BZRNetworkManager *network;
@property (strong, nonatomic) BZRStorageManager *storage;

@end

@implementation BZRDataManager

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
    if (![self isSessionValid]) {
        [self.network getClientCredentialsOnCompletion:^(BOOL success, BZRToken *token, NSError *error) {
            [weakSelf setupTokenAndAddAuthHeader:token];
            if (success) {
                completion(YES, nil);
            } else {
                completion(NO, error);
            }
        }];
    } else {
        
    }
}

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result
{
    WEAK_SELF;
    [self.network signInWithUserName:userName password:password withResult:^(BOOL success, BZRToken *token, NSError *error) {
        if (success) {
            [weakSelf setupTokenAndAddAuthHeader:token];
        }
        return result(success, error);
    }];
}

- (void)signUpWithUserFirstName:(NSString *)firstName andUserLastName:(NSString *)lastName andEmail:(NSString *)email withResult:(SuccessBlock)result
{
    [self.network signUpWithUserFirstName:firstName andUserLastName:lastName andEmail:email withResult:^(BOOL success, NSError *error) {
        return result(success, error);
    }];
}

- (void)authorizeWithFacebookWithResult:(SuccessBlock)result
{
    WEAK_SELF;
    [self.network authorizeWithFacebookWithResult:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        weakSelf.storage.currentProfile = userProfile;
        result(success, error);
    }];
}

#pragma mark - Private methods

- (void)setupTokenAndAddAuthHeader:(BZRToken *)token
{
    self.storage.token = token;
    
    [self.network.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
}

- (BOOL)isSessionValid
{
    NSString *accessToken       = self.storage.token.accessToken;
    NSDate *tokenExpirationDate = self.storage.token.expirationDate;
    
    if (accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending)) {
        return YES;
    }
    return NO;
}


@end
