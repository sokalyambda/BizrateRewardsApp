//
//  BZRApplicationToken.m
//  BizrateRewards
//
//  Created by Eugenity on 06.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRApplicationToken.h"

static NSString *const kAccessTokenKey  = @"access_token";
static NSString *const kExpiresInKey    = @"expires_in";
static NSString *const kScopeTokenKey   = @"scope";
static NSString *const kTypeTokenKey    = @"token_type";

@implementation BZRApplicationToken

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _accessToken    = response[kAccessTokenKey];
        _scope          = response[kScopeTokenKey];
        _tokenType      = response[kTypeTokenKey];
        
        NSTimeInterval expiresIn = [response[kExpiresInKey] integerValue];
        _expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
    }
    return self;
}

@end
