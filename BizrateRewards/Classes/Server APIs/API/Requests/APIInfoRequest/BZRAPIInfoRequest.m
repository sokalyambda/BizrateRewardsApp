//
//  BZRAPIInfoRequest.m
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAPIInfoRequest.h"

#import "BZRServerAPIEntity.h"

static NSString *requestAction = @"info";

@implementation BZRAPIInfoRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"GET";
        
        _userAuthorizationRequired = NO;
        _applicationAuthorizationRequired = NO;
        
        [self setParametersWithParamsData:nil];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.apiEntity = [[BZRServerAPIEntity alloc] initWithServerResponse:responseObject];
        return !!self.apiEntity;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
