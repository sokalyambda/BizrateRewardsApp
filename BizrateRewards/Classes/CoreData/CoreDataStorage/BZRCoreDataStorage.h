//
//  BZRCoreDataStorage.h
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class Environment;

@interface BZRCoreDataStorage : NSObject

+ (void)saveContext;

//MARK: Environments
+ (Environment *)addNewEnvironmentWithName:(NSString *)environmentName
                   andAPIEndpointURLString:(NSString *)apiEndpoint
                          andMixpanelToken:(NSString *)mixpanelToken;
+ (Environment *)getEnvironmentByName:(NSString *)envName;
+ (Environment *)getCurrentEnvironment;
+ (NSArray *)getAllEnvironments;

@end
