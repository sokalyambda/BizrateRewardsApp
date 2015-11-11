//
//  BZREnvironmentService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 30.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class BZREnvironment;

@interface BZREnvironmentService : NSObject

+ (NSArray *)eligibleEnvironmentsArray;
+ (NSArray *)possibleMixPanels;

+ (BZREnvironment *)defaultEnvironment;

+ (void)setEnvironment:(BZREnvironment *)environment
      toDefaultsForKey:(NSString *)key;
+ (BZREnvironment *)environmentFromDefaultsForKey:(NSString *)key;

+ (void)encodeEnvironment:(BZREnvironment *)environment
                withCoder:(NSCoder *)encoder;
+ (BZREnvironment *)decodeEnvironment:(BZREnvironment *)environment
                          withDecoder:(NSCoder *)decoder;

@end
