//
//  BZREnvironmentService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 30.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class Environment;

@interface BZREnvironmentService : NSObject

+ (void)createEligibleEnvironments;
+ (NSArray *)possibleMixPanels;

+ (Environment *)defaultEnvironment;

@end
