//
//  BZRDeleteTakenSurveysRequest.m
//  Bizrate Rewards
//
//  Created by Eugenity on 26.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRDeleteTakenSurveysRequest.h"

static NSString *requestAction = @"user/survey";

@implementation BZRDeleteTakenSurveysRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        self.action = [self requestAction];
        _method = @"DELETE";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        [self setParametersWithParamsData:nil];
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
