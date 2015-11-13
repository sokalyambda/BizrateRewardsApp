//
//  BZRFacebookProfileService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class BZRFacebookProfile;

@interface BZRFacebookProfileService : NSObject

+ (BZRFacebookProfile *)facebookProfileFromServerResponse:(NSDictionary *)response;

@end
