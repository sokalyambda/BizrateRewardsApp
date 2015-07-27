//
//  BZRSignInRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 14.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignInRequest.h"

#import "BZRUserToken.h"

#import "BZRApiConstants.h"

static NSString *kEmail         = @"username";
static NSString *kPassword      = @"password";

@implementation BZRSignInRequest

#pragma mark - Lifecycle

- (instancetype)initWithEmail:(NSString*)email andPassword:(NSString*)password
{
    if (self = [super init]) {
                
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{kEmail: email, kPassword: password, GrantTypeKey: kPassword, ClientIdKey: kClientIdValue, ClientSecretKey: kClientSecretValue}];
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError* __autoreleasing  *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.userToken = [[BZRUserToken alloc] initWithServerResponse:responseObject];
        return !!self.userToken;
    }
}

@end
