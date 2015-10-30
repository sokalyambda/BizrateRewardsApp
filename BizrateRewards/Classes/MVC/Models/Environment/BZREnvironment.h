//
//  BZREnvironment.h
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@interface BZREnvironment : NSObject

@property (strong, nonatomic, readonly) NSString *environmentName;
@property (strong, nonatomic) NSString *apiEndpointURLString;
@property (strong, nonatomic) NSString *mixPanelToken;

+ (instancetype)environmentWithName:(NSString *)name;

- (void)setEnvironmentToDefaultsForKey:(NSString *)key;
+ (BZREnvironment *)environmentFromDefaultsForKey:(NSString *)key;

@end
