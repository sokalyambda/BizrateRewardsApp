//
//  BZRRenewSessionTokenRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRRenewSessionTokenRequest.h"

#import "BZRApiConstants.h"

#import "BZRStorageManager.h"

#import "BZRUserToken.h"

static NSString *const kRefreshToken = @"refresh_token";

@implementation BZRRenewSessionTokenRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{GrantTypeKey: GrantTypeRefreshToken, ClientIdKey: kClientIdValue, ClientSecretKey: kClientSecretValue, kRefreshToken: [BZRStorageManager sharedStorage].userToken.refreshToken}];
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.userToken = [[BZRUserToken alloc] initWithServerResponse:responseObject];
        return !!self.userToken;
    }
}

@end
