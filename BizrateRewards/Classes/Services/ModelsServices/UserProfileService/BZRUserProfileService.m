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
static NSString *const kAllowRedemption         = @"allow_redemption";

static NSString *const kUserId                  = @"userId";
static NSString *const kShareCode               = @"share_code";

static NSString *const kIsTestUser              = @"is_test_user";

@implementation BZRUserProfileService

#pragma mark - Actions

+ (BZRUserProfile *)userProfileWithServerResponse:(NSDictionary *)response
{
    BZRUserProfile *userProfile = [[BZRUserProfile alloc] init];
    userProfile.firstName       = response[kFirstName];
    userProfile.lastName        = response[kLastName];
    userProfile.email           = response[kEmail];
    userProfile.contactID       = response[kContactID];
    userProfile.dateOfBirth     = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:response[kDateOfBirth]];
    userProfile.pointsAmount    = [response[kPointsAmount] integerValue];
    userProfile.pointsRequired  = [response[kPointsRequired] integerValue];
    userProfile.testUser        = [response[kIsTestUser] boolValue];
    userProfile.redemptionURL   = [NSURL URLWithString:response[kRedemptionURL]];
    userProfile.allowRedemption = [response[kAllowRedemption] boolValue];
    
    userProfile.userId          = [response[kUserId] longLongValue];
    userProfile.shareCode       = response[kShareCode];
    
    userProfile.genderString = response[kGender];
    
    return userProfile;
}

@end
