//
//  BZRStorageManager.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRStorageManager.h"

@interface BZRStorageManager ()

@end

@implementation BZRStorageManager

#pragma mark - Accessors

- (BZRFacebookProfile *)facebookProfile
{
    if (!_facebookProfile) {
        _facebookProfile = [BZRFacebookProfile facebookProfileFromDefaultsForKey:FBCurrentProfile];
    }
    return _facebookProfile;
}

- (NSString *)deviceUDID
{
    _deviceUDID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    return _deviceUDID;
}

- (NSString *)deviceName
{
    _deviceName = [UIDevice currentDevice].name;
    return _deviceName;
}

- (BZRUserToken *)userToken
{
    if (!_userToken) {
        _userToken = self.temporaryUserToken;
    }
    return _userToken;
}

#pragma mark - Lifecycle

+ (instancetype)sharedStorage
{
    static BZRStorageManager *storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[BZRStorageManager alloc] init];
    });
    return storage;
}

@end
