//
//  BZREnvironment.m
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZREnvironment.h"

static NSString *const kEnvironmentName = @"environmentName";
static NSString *const kAPIURLString    = @"APIURLString";
static NSString *const kMixPanelToken   = @"mixPanelToken";

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
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.environmentName forKey:kEnvironmentName];
    [encoder encodeObject:self.apiEndpointURLString forKey:kAPIURLString];
    [encoder encodeObject:self.mixPanelToken forKey:kMixPanelToken];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        _environmentName        = [decoder decodeObjectForKey:kEnvironmentName];
        _apiEndpointURLString   = [decoder decodeObjectForKey:kAPIURLString];
        _mixPanelToken          = [decoder decodeObjectForKey:kMixPanelToken];

    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setEnvironmentToDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
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
