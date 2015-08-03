//
//  BZRRenewSessionTokenRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRRenewSessionTokenRequest.h"

#import "BZRStorageManager.h"

static NSString *const kRefreshToken = @"refresh_token";

@implementation BZRRenewSessionTokenRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *refreshTokenValue = [BZRStorageManager sharedStorage].userToken.refreshToken;
        if (refreshTokenValue) {
            [self.baseAuthParameters setObject:refreshTokenValue forKey:kRefreshToken];
        }
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        [self setParametersWithParamsData:self.baseAuthParameters];
    }
    return self;
}

- (NSString *)grantType
{
    return kRefreshToken;
}

@end
