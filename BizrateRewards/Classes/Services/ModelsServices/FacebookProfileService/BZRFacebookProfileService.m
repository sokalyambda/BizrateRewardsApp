//
//  BZRFacebookProfileService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRFacebookProfileService.h"

#import "BZRFacebookProfile.h"

#import "BZRFacebookProfile.h"

#import "BZRCoreDataStorage.h"

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
    BZRFacebookProfile *currentFacebookProfile = [BZRCoreDataStorage getCurrentFacebookProfile];
    if (currentFacebookProfile) {
        [BZRCoreDataStorage removeFacebookProfile:currentFacebookProfile];
    }
    
    NSString *firstName = response[kFirstName];
    NSString *lastName = response[kLastName];
    NSString *fullName = response[kFullName];
    long long userId = [response[kUserId] longLongValue];
    NSString *email = response[kEmail];
    NSString *genderString = [response[kGender] capitalizedString];
    NSString *avararURL = response[kPicture][kData][kURL];
    
    return [BZRCoreDataStorage addFacebookProfileWithFirstName:firstName
                                                   andLastName:lastName
                                                   andFullName:fullName
                                               andGenderString:genderString
                                                      andEmail:email
                                            andAvatarURLString:avararURL
                                                     andUserId:userId];
}

@end
