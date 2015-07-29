//
//  BZRGetClientCredentialsRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 26.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetClientCredentialsRequest.h"

static NSString *const kGrantTypeClientCredentials = @"client_credentials";

@implementation BZRGetClientCredentialsRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        [self setParametersWithParamsData:self.baseAuthParameters];
    }
    return self;
}

- (NSString *)grantType
{
    return kGrantTypeClientCredentials;
}

@end
