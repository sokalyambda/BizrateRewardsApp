//
//  BZRToken.m
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRUserToken.h"

static NSString *const kRefreshTokenKey = @"refresh_token";

@implementation BZRUserToken

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super initWithServerResponse:response];
    if (self) {
        _refreshToken = response[kRefreshTokenKey];
    }
    return self;
}

@end
