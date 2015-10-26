//
//  BZRUpdateNotificationsAndGeolocationPermissionsRequest.m
//  Bizrate Rewards
//
//  Created by Eugenity on 26.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRUpdateNotificationsAndGeolocationPermissionsRequest.h"

static NSString *const requestAction = @"users/notifications";

static NSString *const kRemoteNotificationsEnabled = @"remoteNotificationsEnabled";
static NSString *const kGeolocationAccessGranted = @"geolocationAccessGranted";

@implementation BZRUpdateNotificationsAndGeolocationPermissionsRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.action = [self requestAction];
        _method = @"PUT";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        BZRUserProfile *currentProfile = [BZRStorageManager sharedStorage].currentProfile;
        
        BOOL remoteNotificationsEnabled = currentProfile.isRemoteNotificationsEnabled;
        BOOL geolocationAccessGranted = currentProfile.isGeolocationAccessGranted;
        
        NSMutableDictionary *parameters = [@{
                                             kRemoteNotificationsEnabled: @(remoteNotificationsEnabled),
                                             kGeolocationAccessGranted: @(geolocationAccessGranted)
                                             } mutableCopy];
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    return !!responseObject;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
