//
//  BZREnvironmentService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 30.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZREnvironmentService.h"

#import "BZREnvironment.h"

static NSString *const kDevelopmentAPIEndpoint      = @"https://api.bizraterewards.com/v1/";
static NSString *const kStagingAPIEndpoint          = @"http://api-stage.bizraterewards.com/v1/";
static NSString *const kProductionAPIEndpoint       = @"https://api.bizraterewards.com/v1/";
//live token aae3e2388125817b27b8afcf99093d97
//test token f818411581cc210c670fe3351a46debe
static NSString *const kDevelopmentMixPanelToken    = @"f818411581cc210c670fe3351a46debe";
static NSString *const kStagingMixPanelToken        = @"stagingMixPanel";
static NSString *const kProductionMixPanelToken     = @"productionMixPanel";

@implementation BZREnvironmentService

+ (NSArray *)eligibleEnvironmentsArray
{
    BZREnvironment *development = [BZREnvironment environmentWithName:LOCALIZED(@"Development")];
    development.apiEndpointURLString = kDevelopmentAPIEndpoint;
    development.mixPanelToken = kDevelopmentMixPanelToken;
    
    BZREnvironment *staging = [BZREnvironment environmentWithName:LOCALIZED(@"Staging")];
    staging.apiEndpointURLString = kStagingAPIEndpoint;
    staging.mixPanelToken = kStagingMixPanelToken;
    
    BZREnvironment *production = [BZREnvironment environmentWithName:LOCALIZED(@"Production")];
    production.apiEndpointURLString = kProductionAPIEndpoint;
    production.mixPanelToken = kProductionMixPanelToken;
    
    return @[development, staging, production];
}

+ (BZREnvironment *)defaultEnvironment
{
    return [self eligibleEnvironmentsArray][0];
}

@end
