//
//  BZRUserProfileService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRUserProfileService.h"

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
static NSString *const kRedemptionURL           = @"redemption_url";

static NSString *const kUserId                  = @"userId";

static NSString *const kIsTestUser              = @"is_test_user";

@implementation BZRUserProfileService

#pragma mark - Actions

+ (BZRUserProfile *)userProfileWithServerResponse:(NSDictionary *)response
{
    BZRUserProfile *userProfile = [[BZRUserProfile alloc] init];
    userProfile.firstName      = response[kFirstName];
    userProfile.lastName       = response[kLastName];
    userProfile.email          = response[kEmail];
    userProfile.contactID      = response[kContactID];
    userProfile.dateOfBirth    = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:response[kDateOfBirth]];
    userProfile.pointsAmount   = [response[kPointsAmount] integerValue];
    userProfile.pointsRequired = [response[kPointsRequired] integerValue];
    userProfile.testUser       = [response[kIsTestUser] boolValue];
    
    userProfile.redemptionURL  = [NSURL URLWithString:response[kRedemptionURL]];
    
    userProfile.userId         = [response[kUserId] longLongValue];
    
    userProfile.genderString = response[kGender];
    
    return userProfile;
}

#pragma mark - NSCoding

+ (void)encodeUserProfile:(BZRUserProfile *)userProfile
                withCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:userProfile.firstName forKey:kFirstName];
    [encoder encodeObject:userProfile.lastName forKey:kLastName];
    [encoder encodeObject:userProfile.email forKey:kEmail];
    [encoder encodeObject:userProfile.dateOfBirth forKey:kDateOfBirth];
    [encoder encodeObject:@(userProfile.isMale) forKey:kIsMale];
    [encoder encodeObject:userProfile.genderString forKey:kGender];
    [encoder encodeObject:userProfile.redemptionURL forKey:kRedemptionURL];
    [encoder encodeObject:@(userProfile.userId) forKey:kUserId];
}

+ (BZRUserProfile *)decodeUserProfile:(BZRUserProfile *)userProfile
                          withDecoder:(NSCoder *)decoder
{
    //decode properties, other class vars
    userProfile.firstName      = [decoder decodeObjectForKey:kFirstName];
    userProfile.lastName       = [decoder decodeObjectForKey:kLastName];
    userProfile.email          = [decoder decodeObjectForKey:kEmail];
    userProfile.dateOfBirth    = [decoder decodeObjectForKey:kDateOfBirth];
    userProfile.isMale         = [[decoder decodeObjectForKey:kIsMale] boolValue];
    userProfile.genderString   = [decoder decodeObjectForKey:kGender];
    userProfile.redemptionURL  = [decoder decodeObjectForKey:kRedemptionURL];
    userProfile.userId         = [[decoder decodeObjectForKey:kUserId] longLongValue];
    return userProfile;
}

#pragma mark - NSUserDefaults

+ (void)setUserProfile:(BZRUserProfile *)userProfile
      toDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:userProfile];
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
