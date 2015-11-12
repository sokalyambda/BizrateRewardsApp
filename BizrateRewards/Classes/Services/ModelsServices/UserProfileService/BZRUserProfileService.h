//
//  BZRUserProfileService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@interface BZRUserProfileService : NSObject

+ (BZRUserProfile *)userProfileWithServerResponse:(NSDictionary *)response;

@end
