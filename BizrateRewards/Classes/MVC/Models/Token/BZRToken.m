//
//  BZRToken.m
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRToken.h"

static NSString *const kAccessTokenKey  = @"access_token";
static NSString *const kRefreshTokenKey = @"refresh_token";
static NSString *const kExpiresInKey    = @"expires_in";
static NSString *const kScopeTokenKey   = @"scope";
static NSString *const kTypeTokenKey    = @"token_type";

@implementation BZRToken

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _accessToken    = response[kAccessTokenKey];
        _refreshToken   = response[kRefreshTokenKey];
        _scope          = response[kScopeTokenKey];
        _tokenType      = response[kTypeTokenKey];
        
        NSTimeInterval expiresIn = [response[kExpiresInKey] integerValue];
        _expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
    }
    return self;
}

@end
