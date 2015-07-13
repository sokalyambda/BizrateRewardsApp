//
//  BZRUserProfile.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRUserProfile.h"

#import "BZRCommonDateFormatter.h"

static NSString *const kFirstName               = @"firstname";
static NSString *const kLastName                = @"lastname";
static NSString *const kEmail                   = @"email";
static NSString *const kDateOfBirth             = @"dob";
static NSString *const kGender                  = @"gender";
static NSString *const kIsMale                  = @"isMale";
static NSString *const kPointsAmount            = @"points";
static NSString *const kIsPushEnabled           = @"isPushEnabled";
static NSString *const kIsGeolocationEnabled    = @"isGeolocationEnabled";

@interface BZRUserProfile ()

@end

@implementation BZRUserProfile

#pragma mark - Accessors

- (BOOL)isMale
{
    _isMale = [self.genderString isEqualToString:@"M"] ? YES : NO;
    return _isMale;
}

- (NSString *)fullName
{
    _fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    return _fullName;
}

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _firstName      = response[kFirstName];
        _lastName       = response[kLastName];
        _email          = response[kEmail];
        _genderString   = response[kGender];
        _dateOfBirth    = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:response[kDateOfBirth]];
        _pointsAmount   = [response[kPointsAmount] integerValue];
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
        _firstName      = [decoder decodeObjectForKey:kFirstName];
        _lastName       = [decoder decodeObjectForKey:kLastName];
        _email          = [decoder decodeObjectForKey:kEmail];
        _dateOfBirth    = [decoder decodeObjectForKey:kDateOfBirth];
        _isMale         = [[decoder decodeObjectForKey:kIsMale] boolValue];
        _pushNotificationsEnabled = [[decoder decodeObjectForKey:kIsPushEnabled] boolValue];
        _geolocationEnabled         = [[decoder decodeObjectForKey:kIsGeolocationEnabled] boolValue];
    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setUserProfileToDefaultsForKey:(NSString *)key {
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
