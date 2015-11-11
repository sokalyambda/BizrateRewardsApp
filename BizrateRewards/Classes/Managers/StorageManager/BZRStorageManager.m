//
//  BZRStorageManager.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRStorageManager.h"

#import "BZRLocationEvent.h"
#import "BZRServerAPIEntity.h"

#import "BZRLocationEventService.h"
#import "BZRFacebookProfileService.h"

@interface BZRStorageManager ()

@end

@implementation BZRStorageManager

#pragma mark - Accessors

- (BZRFacebookProfile *)facebookProfile
{
    if (!_facebookProfile) {
        _facebookProfile = [BZRFacebookProfileService facebookProfileFromDefaultsForKey:FBCurrentProfile];
    }
    return _facebookProfile;
}

- (BZRLocationEvent *)lastReceivedLocationEvent
{
    if (!_lastReceivedLocationEvent) {
        _lastReceivedLocationEvent = [BZRLocationEventService locationEventFromDefaultsForKey:LastReceivedLocationEvent];
    }
    return _lastReceivedLocationEvent;
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

#pragma mark - Actions

/**
 *  If there is no user access token but temporary token exists - swap these values
 */
- (void)swapTokens
{
    if (!self.userToken) {
        self.userToken = self.temporaryUserToken;
        self.temporaryUserToken = nil;
    }
}

@end
