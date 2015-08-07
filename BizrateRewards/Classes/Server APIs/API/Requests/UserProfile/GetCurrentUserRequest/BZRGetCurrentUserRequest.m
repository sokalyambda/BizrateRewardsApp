//
//  BZRGetCurrentUserRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetCurrentUserRequest.h"

static NSString *const requestAction = @"user/me";

@implementation BZRGetCurrentUserRequest

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.action = [self requestAction];
        _method = @"GET";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        NSDictionary *parameters = @{};
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError* __autoreleasing  *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.currentUserProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        return !!self.currentUserProfile;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
