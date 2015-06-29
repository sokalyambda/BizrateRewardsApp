//
//  BZRUserProfile.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRUserProfile.h"

static NSString *const kFirstName               = @"firstName";
static NSString *const kLastName                = @"lastName";
static NSString *const kEmail                   = @"email";
static NSString *const kDateOfBirth             = @"dateOfBirth";
static NSString *const kIsMale                  = @"gender";
static NSString *const kIsPushEnabled           = @"isPushEnabled";
static NSString *const kIsGeolocationEnabled    = @"isGeolocationEnabled";


@interface BZRUserProfile ()

@end

@implementation BZRUserProfile

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - NSCoder methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.firstName forKey:kFirstName];
    [encoder encodeObject:self.lastName forKey:kLastName];
    [encoder encodeObject:self.email forKey:kEmail];
    [encoder encodeObject:self.dateOfBirth forKey:kDateOfBirth];
    [encoder encodeObject:@(self.isMale) forKey:kIsMale];
    [encoder encodeObject:@(self.isPushNotificationsEnabled) forKey:kIsPushEnabled];
    [encoder encodeObject:@(self.isGeolocationEnabled) forKey:kIsGeolocationEnabled];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        self.firstName      = [decoder decodeObjectForKey:kFirstName];
        self.lastName       = [decoder decodeObjectForKey:kLastName];
        self.email          = [decoder decodeObjectForKey:kEmail];
        self.dateOfBirth    = [decoder decodeObjectForKey:kDateOfBirth];
        self.isMale         = [[decoder decodeObjectForKey:kIsMale] boolValue];
        self.pushNotificationsEnabled = [[decoder decodeObjectForKey:kIsPushEnabled] boolValue];
        self.geolocationEnabled         = [[decoder decodeObjectForKey:kIsGeolocationEnabled] boolValue];
    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setCityToDefaultsForKey:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (BZRUserProfile *)getUserProfileFromDefaultsForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    BZRUserProfile *userProfile = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return userProfile;
}


@end
