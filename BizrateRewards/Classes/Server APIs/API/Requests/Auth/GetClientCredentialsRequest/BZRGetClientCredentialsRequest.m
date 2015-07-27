//
//  BZRGetClientCredentialsRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 26.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetClientCredentialsRequest.h"

#import "BZRApplicationToken.h"

#import "BZRApiConstants.h"

static NSString *const kGrantTypeClientCredentials = @"client_credentials";

@implementation BZRGetClientCredentialsRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        NSDictionary *parameters = @{GrantTypeKey: kGrantTypeClientCredentials,
                                     ClientIdKey: kClientIdValue,
                                     ClientSecretKey: kClientSecretValue
                                     };
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.applicationToken = [[BZRApplicationToken alloc] initWithServerResponse:responseObject];
        return !!self.applicationToken;
    }
}

@end
