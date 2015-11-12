//
//  BZRUserProfile.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRUserProfile.h"

#import "BZRPushNotifiactionService.h"
#import "BZRUserProfileService.h"

#import "BZRLocationObserver.h"

@interface BZRUserProfile ()

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

- (BOOL)isRemoteNotificationsEnabled
{
    return [BZRPushNotifiactionService isPushNotificationsEnabled];
}

- (BOOL)isGeolocationAccessGranted
{
    return [BZRLocationObserver sharedObserver].isAuthorized;
}

@end
