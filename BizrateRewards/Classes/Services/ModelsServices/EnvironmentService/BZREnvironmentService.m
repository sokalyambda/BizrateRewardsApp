//
//  BZREnvironmentService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 30.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZREnvironmentService.h"

#import "BZREnvironment.h"

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
    return [[self eligibleEnvironmentsArray] lastObject]; //production
}

#pragma mark - NSCoding

+ (void)encodeEnvironment:(BZREnvironment *)environment
                withCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:environment.environmentName forKey:kEnvironmentName];
    [encoder encodeObject:environment.apiEndpointURLString forKey:kAPIURLString];
    [encoder encodeObject:environment.mixPanelToken forKey:kMixPanelToken];
}

+ (BZREnvironment *)decodeEnvironment:(BZREnvironment *)environment
                          withDecoder:(NSCoder *)decoder
{
    environment.environmentName        = [decoder decodeObjectForKey:kEnvironmentName];
    environment.apiEndpointURLString   = [decoder decodeObjectForKey:kAPIURLString];
    environment.mixPanelToken          = [decoder decodeObjectForKey:kMixPanelToken];
    
    return environment;
}

#pragma mark - NSUserDefaults

+ (void)setEnvironment:(BZREnvironment *)environment
      toDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:environment];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        [defaults removeObjectForKey:key];
    }
    
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (BZREnvironment *)environmentFromDefaultsForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        return nil;
    }
    
    NSData *encodedObject = [defaults objectForKey:key];
    BZREnvironment *environment = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return environment;
}

@end
