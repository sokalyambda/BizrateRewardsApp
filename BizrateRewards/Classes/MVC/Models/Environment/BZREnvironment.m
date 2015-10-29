//
//  BZREnvironment.m
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZREnvironment.h"

@implementation BZREnvironment

#pragma mark - Lifecycle

- (instancetype)initWithEnvironmentName:(NSString *)name
{
    self = [super init];
    if (self) {
        _environmentName = name;
    }
    return self;
}

+ (instancetype)environmentWithName:(NSString *)name
{
    return [[self alloc] initWithEnvironmentName:name];
}

@end
