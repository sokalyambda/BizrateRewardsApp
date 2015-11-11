//
//  BZRServerAPIEntityService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRServerAPIEntityService.h"

#import "BZRServerAPIEntity.h"

static NSString *const kAPIEnv      = @"env";
static NSString *const kAPIBranch   = @"branch";
static NSString *const kAPICommit   = @"commit";
static NSString *const kAPIName     = @"name";
static NSString *const kAPIVersion  = @"version";

@implementation BZRServerAPIEntityService

#pragma mark - Actions

+ (BZRServerAPIEntity *)serverAPIEntityFromServerResponse:(NSDictionary *)response
{
    BZRServerAPIEntity *serverAPIEntity = [[BZRServerAPIEntity alloc] init];
    serverAPIEntity.apiEnv     = response[kAPIEnv];
    serverAPIEntity.apiBranch  = response[kAPIBranch];
    serverAPIEntity.apiCommit  = response[kAPICommit];
    serverAPIEntity.apiName    = response[kAPIName];
    serverAPIEntity.apiVersion = response[kAPIVersion];
    
    return serverAPIEntity;
}

@end
