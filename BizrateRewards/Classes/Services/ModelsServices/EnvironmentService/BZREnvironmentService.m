//
//  BZREnvironmentService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 30.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZREnvironmentService.h"

#import "BZRCoreDataStorage.h"

#import <Mixpanel/Mixpanel.h>

static NSString *const kDevelopmentAPIEndpoint      = @"http://devxxx.ngrok.io/v1/";
static NSString *const kStagingAPIEndpoint          = @"http://api-stage.bizraterewards.com/v1/";
static NSString *const kProductionAPIEndpoint       = @"https://api.bizraterewards.com/v1/";

//test token f818411581cc210c670fe3351a46debe
static NSString *const kDevelopmentMixPanelToken    = @"a41e6ca3f37c963b273649b0436e5de5"; //live development
static NSString *const kStagingMixPanelToken        = @"bf2a5a29d476a3f626ff7c1fa35d4e3e"; //live staging
static NSString *const kProductionMixPanelToken     = @"aae3e2388125817b27b8afcf99093d97"; //live production

static NSString *const kEnvironmentName = @"environmentName";
static NSString *const kAPIURLString    = @"APIURLString";
static NSString *const kMixPanelToken   = @"mixPanelToken";

static NSArray *_possibleMixPanels = nil;

@implementation BZREnvironmentService

+ (NSArray *)possibleMixPanels
{
    if (!_possibleMixPanels) {
        _possibleMixPanels = @[
                               [[Mixpanel alloc] initWithToken:kDevelopmentMixPanelToken andFlushInterval:1],
                               [[Mixpanel alloc] initWithToken:kStagingMixPanelToken andFlushInterval:1],
                               [[Mixpanel alloc] initWithToken:kProductionMixPanelToken andFlushInterval:1]];
    }
    return _possibleMixPanels;
}

/**
 *  If environments array doesn't exist in coreData - create it
 */
+ (void)createEligibleEnvironments
{
    NSArray *eligibleEnvironments = [BZRCoreDataStorage getAllEnvironments];
    if (!eligibleEnvironments.count) {
        [BZRCoreDataStorage addNewEnvironmentWithName:LOCALIZED(@"Development")
                              andAPIEndpointURLString:kDevelopmentAPIEndpoint
                                     andMixpanelToken:kDevelopmentMixPanelToken];
        [BZRCoreDataStorage addNewEnvironmentWithName:LOCALIZED(@"Staging")
                              andAPIEndpointURLString:kStagingAPIEndpoint
                                     andMixpanelToken:kStagingMixPanelToken];
        [BZRCoreDataStorage addNewEnvironmentWithName:LOCALIZED(@"Production")
                              andAPIEndpointURLString:kProductionAPIEndpoint
                                     andMixpanelToken:kProductionMixPanelToken];
    }
}

/**
 *  Production environment is default value
 */
+ (Environment *)defaultEnvironment
{
    [self createEligibleEnvironments];
    
    Environment *env = [BZRCoreDataStorage getEnvironmentByName:LOCALIZED(@"Production")]; //production
    
    return env;
}

@end
