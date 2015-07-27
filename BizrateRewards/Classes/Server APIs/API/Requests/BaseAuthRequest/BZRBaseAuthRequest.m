//
//  BZRBaseAuthRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 14.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthRequest.h"

static NSString *requestAction = @"oauth/token";

@implementation BZRBaseAuthRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        _autorizationRequired = NO;
    }
    return self;
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
