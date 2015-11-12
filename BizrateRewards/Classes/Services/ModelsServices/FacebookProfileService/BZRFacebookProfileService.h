//
//  BZRFacebookProfileService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class FacebookProfile;

@interface BZRFacebookProfileService : NSObject

+ (FacebookProfile *)facebookProfileFromServerResponse:(NSDictionary *)response;

@end
