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

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result
{
    WEAK_SELF;
    [self.network signInWithUserName:userName password:password withResult:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        weakSelf.storage.currentProfile = userProfile;
        return result(success, error);
    }];
}

- (void)signUpWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result
{
    WEAK_SELF;
    [self.network signUpWithUserName:userName password:password withResult:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        weakSelf.storage.currentProfile = userProfile;
        return result(success, error);
    }];
}

- (void)signInWithFacebookWithResult:(SuccessBlock)result
{
    WEAK_SELF;
    [self.network signInWithFacebookWithResult:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        weakSelf.storage.currentProfile = userProfile;
        result(success, error);
    }];
}

- (void)signUpWithFacebookWithResult:(SuccessBlock)result
{
    WEAK_SELF;
    [self.network signUpWithFacebookWithResult:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        weakSelf.storage.currentProfile = userProfile;
        return result(success, error);
    }];
}

@end
