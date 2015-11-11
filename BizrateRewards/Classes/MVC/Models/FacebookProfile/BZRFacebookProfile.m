//
//  BZRFacebookProfile.m
//  BizrateRewards
//
//  Created by Eugenity on 30.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFacebookProfile.h"

#import "BZRFacebookProfileService.h"

@interface BZRFacebookProfile ()<NSCoding>

@end

@implementation BZRFacebookProfile

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [BZRFacebookProfileService encodeFacebookProfile:self withCoder:encoder];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    return [BZRFacebookProfileService decodeFacebookProfile:self withDecoder:decoder];
}

@end
