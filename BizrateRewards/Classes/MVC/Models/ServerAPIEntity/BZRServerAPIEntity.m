//
//  BZRServerAPIEntity.m
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRServerAPIEntity.h"

static NSString *const kAPIEnv      = @"env";
static NSString *const kAPIBranch   = @"branch";
static NSString *const kAPICommit   = @"commit";
static NSString *const kAPIName     = @"name";
static NSString *const kAPIVersion  = @"version";

@implementation BZRServerAPIEntity

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _apiEnv     = response[kAPIEnv];
        _apiBranch  = response[kAPIBranch];
        _apiCommit  = response[kAPICommit];
        _apiName    = response[kAPIName];
        _apiVersion = response[kAPIVersion];
    }
    return self;
}

@end
