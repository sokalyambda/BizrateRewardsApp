//
//  BZRUserProfile.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRUserProfile.h"

#import "BZRCommonDateFormatter.h"

static NSString *const kFirstName               = @"firstname";
static NSString *const kLastName                = @"lastname";
static NSString *const kEmail                   = @"email";
static NSString *const kDateOfBirth             = @"dob";
static NSString *const kGender                  = @"gender";
static NSString *const kIsMale                  = @"isMale";
static NSString *const kPointsAmount            = @"points_awarded";
static NSString *const kContactID               = @"ref_contact_id";
static NSString *const kPointsRequired          = @"points_next_redemption";

@interface BZRUserProfile ()<NSCoding>

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation BZRUserProfile

@synthesize avatarURL = _avatarURL;

#pragma mark - Accessors

- (NSUserDefaults *)defaults
{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (NSURL *)avatarURL
{
    _avatarURL = [self.defaults URLForKey:self.email];
    return _avatarURL;
}

- (void)setAvatarURL:(NSURL *)avatarURL
{
    [self.defaults setURL:avatarURL forKey:self.email];
    _avatarURL = avatarURL;
}

- (BOOL)isMale
{
    _isMale = [[self.genderString substringToIndex:1] isEqualToString:@"M"] ? YES : NO;
    return _isMale;
}

- (NSString *)fullName
{
    _fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    return _fullName;
}

- (void)setGenderString:(NSString *)genderString
{
    if ([genderString isEqualToString:@"M"]) {
        _genderString = NSLocalizedString(@"Male", nil);
    } else if ([genderString isEqualToString:@"F"]) {
        _genderString = NSLocalizedString(@"Female", nil);
    } else {
        _genderString = genderString;
    }
}

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _firstName      = response[kFirstName];
        _lastName       = response[kLastName];
        _email          = response[kEmail];
        _contactID      = response[kContactID];
        _dateOfBirth    = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:response[kDateOfBirth]];
        _pointsAmount   = [response[kPointsAmount] integerValue];
        _pointsRequired = [response[kPointsRequired] integerValue];
        
        self.genderString   = response[kGender];
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
    [encoder encodeObject:self.genderString forKey:kGender];
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
        _genderString   = [decoder decodeObjectForKey:kGender];
    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setUserProfileToDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        [defaults removeObjectForKey:key];
    }
    
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (BZRUserProfile *)userProfileFromDefaultsForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        return nil;
    }
    
    NSData *encodedObject = [defaults objectForKey:key];
    BZRUserProfile *userProfile = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return userProfile;
}

@end
