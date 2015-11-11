//
//  BZRFacebookProfileService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRFacebookProfileService.h"

#import "BZRFacebookProfile.h"

static NSString *const kFirstName = @"first_name";
static NSString *const kLastName = @"last_name";
static NSString *const kFullName = @"name";
static NSString *const kUserId = @"id";
static NSString *const kEmail = @"email";
static NSString *const kAvatarURL = @"avatarURL";

static NSString *const kPicture = @"picture";
static NSString *const kData = @"data";
static NSString *const kURL = @"url";
static NSString *const kGender = @"gender";

@implementation BZRFacebookProfileService

+ (BZRFacebookProfile *)facebookProfileFromServerResponse:(NSDictionary *)response
{
    BZRFacebookProfile *facebookProfile = [[BZRFacebookProfile alloc] init];
    facebookProfile.firstName = response[kFirstName];
    facebookProfile.lastName = response[kLastName];
    facebookProfile.fullName = response[kFullName];
    facebookProfile.userId = [response[kUserId] longLongValue];
    facebookProfile.email = response[kEmail];
    facebookProfile.genderString = [response[kGender] capitalizedString];
    
    facebookProfile.avararURL = [NSURL URLWithString:response[kPicture][kData][kURL]];
    
    return facebookProfile;
}

#pragma mark - NSCoding methods

+ (void)encodeFacebookProfile:(BZRFacebookProfile *)facebookProfile
                    withCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:facebookProfile.firstName forKey:kFirstName];
    [encoder encodeObject:facebookProfile.lastName forKey:kLastName];
    [encoder encodeObject:facebookProfile.email forKey:kEmail];
    [encoder encodeObject:facebookProfile.fullName forKey:kFullName];
    [encoder encodeObject:@(facebookProfile.userId) forKey:kUserId];
    [encoder encodeObject:facebookProfile.avararURL forKey:kAvatarURL];
    [encoder encodeObject:facebookProfile.genderString forKey:kGender];
}

+ (BZRFacebookProfile *)decodeFacebookProfile:(BZRFacebookProfile *)facebookProfile
                                  withDecoder:(NSCoder *)decoder
{
    //decode properties, other class vars
    facebookProfile.firstName      = [decoder decodeObjectForKey:kFirstName];
    facebookProfile.lastName       = [decoder decodeObjectForKey:kLastName];
    facebookProfile.email          = [decoder decodeObjectForKey:kEmail];
    facebookProfile.fullName       = [decoder decodeObjectForKey:kFullName];
    facebookProfile.userId         = [[decoder decodeObjectForKey:kUserId] longLongValue];
    facebookProfile.avararURL      = [decoder decodeObjectForKey:kAvatarURL];
    facebookProfile.genderString   = [decoder decodeObjectForKey:kGender];

    return facebookProfile;
}

#pragma mark - NSUserDefaults methods

+ (void)setFacebookProfile:(BZRFacebookProfile *)facebookProfile
          toDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:facebookProfile];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        [defaults removeObjectForKey:key];
    }
    
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (BZRFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        return nil;
    }
    
    NSData *encodedObject = [defaults objectForKey:key];
    BZRFacebookProfile *userProfile = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return userProfile;
}

@end
