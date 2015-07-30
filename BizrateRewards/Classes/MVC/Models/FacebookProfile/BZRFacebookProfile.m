//
//  BZRFacebookProfile.m
//  BizrateRewards
//
//  Created by Eugenity on 30.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFacebookProfile.h"

static NSString *const kFirstName = @"";
static NSString *const kLastName = @"";
static NSString *const kFullName = @"name";
static NSString *const kUserId = @"id";
static NSString *const kEmail = @"email";
static NSString *const kAvatarURL = @"avatarURL";

@implementation BZRFacebookProfile

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _firstName = response[kFirstName];
        _lastName = response[kLastName];
        _fullName = response[kFullName];
        _userId = [response[kUserId] longLongValue];
        _email = response[kEmail];
        
        _avararURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200", response[kUserId]]];
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
    [encoder encodeObject:self.fullName forKey:kFullName];
    [encoder encodeObject:@(self.userId) forKey:kUserId];
    [encoder encodeObject:self.avararURL forKey:kAvatarURL];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        _firstName      = [decoder decodeObjectForKey:kFirstName];
        _lastName       = [decoder decodeObjectForKey:kLastName];
        _email          = [decoder decodeObjectForKey:kEmail];
        _fullName       = [decoder decodeObjectForKey:kFullName];
        _userId         = [[decoder decodeObjectForKey:kUserId] longLongValue];
        _avararURL      = [decoder decodeObjectForKey:kAvatarURL];
    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setFacebookProfileToDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        return;
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
