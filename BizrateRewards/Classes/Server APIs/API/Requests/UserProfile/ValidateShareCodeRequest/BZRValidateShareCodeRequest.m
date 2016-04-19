//
//  BZRValidateShareCodeRequest.m
//  Bizrate Rewards
//
//  Created by Myroslava Polovka on 4/13/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import "BZRValidateShareCodeRequest.h"

@implementation BZRValidateShareCodeRequest

static NSString *const requestAction = @"user/sharecode";

static NSString *const kShareCode = @"share_code";

- (instancetype)initWithShareCode:(NSString *)shareCode
{
    self = [super init];
    if (self) {
        
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].applicationToken.accessToken] forKey:@"Authorization"];
        
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = NO;
        _applicationAuthorizationRequired = YES;
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        
        NSDictionary *parameters = @{kShareCode:shareCode};
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    return !!responseObject;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
