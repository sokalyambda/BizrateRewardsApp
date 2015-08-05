//
//  BZRSendDeviceDataRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 03.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSendDeviceDataRequest.h"

static NSString *const requestAction    = @"user/device";

static NSString *const kDeviceAPNSToken = @"device_token";
static NSString *const kDeviceId        = @"device_uid";
static NSString *const kDeviceName      = @"name";

@implementation BZRSendDeviceDataRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        NSString *deviceId = [BZRStorageManager sharedStorage].deviceUDID;
        NSString *deviceToken = [BZRStorageManager sharedStorage].deviceToken;
        NSString *deviceName = [BZRStorageManager sharedStorage].deviceName;
        
        NSDictionary *parameters = @{kDeviceAPNSToken: deviceToken, kDeviceId: deviceId, kDeviceName: deviceName};
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (NSString *)requestAction
{
    return requestAction;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    }
    return YES;
}

@end
