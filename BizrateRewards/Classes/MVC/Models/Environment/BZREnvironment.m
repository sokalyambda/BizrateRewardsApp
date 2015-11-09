//
//  BZREnvironment.m
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZREnvironment.h"

#import "BZREnvironmentService.h"

@interface BZREnvironment ()<NSCoding>

@end

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

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [BZREnvironmentService encodeEnvironment:self withCoder:encoder];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        [BZREnvironmentService decodeEnvironment:self withDecoder:decoder];
    }
    return self;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[BZREnvironment class]]) {
        return NO;
    }
    
    return [self isEqualToEnvironment:(BZREnvironment *)object];
}

- (BOOL)isEqualToEnvironment:(BZREnvironment *)environment
{
    if (!environment) {
        return NO;
    }
    
    BOOL haveEqualNames     = [self.environmentName isEqualToString:environment.environmentName];
    BOOL haveEqualURLs      = [self.apiEndpointURLString isEqualToString:environment.apiEndpointURLString];
    BOOL haveEqualTokens    = [self.mixPanelToken isEqualToString:environment.mixPanelToken];
    
    return haveEqualNames && haveEqualTokens && haveEqualURLs;
}

- (NSUInteger)hash
{
    return [self.mixPanelToken hash] ^ [self.environmentName hash];
}

@end
