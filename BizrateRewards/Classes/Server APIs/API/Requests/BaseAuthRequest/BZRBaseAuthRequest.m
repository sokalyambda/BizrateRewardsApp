//
//  BZRBaseAuthRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 14.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthRequest.h"

static NSString *requestAction      = @"oauth/token";

static NSString *kClientId          = @"client_id";
static NSString *kClientSecret      = @"client_secret";
static NSString *kGrantType         = @"grant_type";

static NSString *kClientIdValue     = @"92196543-9462-4b90-915a-738c9b4b558f";
static NSString *kClientSecretValue = @"8a9da763-9503-4093-82c2-6b22b8eb9a12";

@implementation BZRBaseAuthRequest

#pragma mark - Accessors

- (NSMutableDictionary *)baseAuthParameters
{
    if (!_baseAuthParameters) {
        _baseAuthParameters = [@{kClientId: kClientIdValue,
                                 kClientSecret: kClientSecretValue,
                                 kGrantType: [self grantType]} mutableCopy];
    }
    return _baseAuthParameters;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = NO;
        _applicationAuthorizationRequired = NO;
    }
    return self;
}

#pragma mark - Actions

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError* __autoreleasing  *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.token = [[BZRUserToken alloc] initWithServerResponse:responseObject];
        return !!self.token;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

- (NSString *)grantType
{
    return @"";
}

@end
