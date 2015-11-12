//
//  BZRCoreDataStorage.m
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRCoreDataStorage.h"

#import "BZRCoreDataManager.h"

#import "Environment.h"

@implementation BZRCoreDataStorage

+ (BZRCoreDataManager *)coreDataManager
{
    return [BZRCoreDataManager sharedCoreDataManager];
}

#pragma mark - Fetch Entities

+ (Environment *)addNewEnvironmentWithName:(NSString *)environmentName
                   andAPIEndpointURLString:(NSString *)apiEndpoint
                          andMixpanelToken:(NSString *)mixpanelToken
{
    Environment *environment = (Environment *)[self.coreDataManager addNewManagedObjectForName:NSStringFromClass([Environment class])];
    
    environment.environmentName         = environmentName;
    environment.apiEndpointURLString    = apiEndpoint;
    environment.mixPanelToken           = mixpanelToken;
    
    [[self coreDataManager] saveContext];
    
    return environment;
}

+ (Environment *)getEnvironmentByName:(NSString *)envName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"environmentName == %@", envName];
    NSArray *filteredArray = [self.coreDataManager getEntities:NSStringFromClass([Environment class]) byPredicate:predicate];
    return [filteredArray firstObject];
}

+ (Environment *)getCurrentEnvironment
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCurrent == YES"];
    NSArray *filteredArray = [self.coreDataManager getEntities:NSStringFromClass([Environment class]) byPredicate:predicate];
    return [filteredArray firstObject];
}

+ (NSArray *)getAllEnvironments
{
    return [self.coreDataManager getEntities:NSStringFromClass([Environment class])];
}

#pragma mark - Actions

+ (void)saveContext
{
    [self.coreDataManager saveContext];
}

@end
