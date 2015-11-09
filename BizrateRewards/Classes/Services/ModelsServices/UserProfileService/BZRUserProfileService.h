//
//  BZRUserProfileService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@interface BZRUserProfileService : NSObject

+ (BZRUserProfile *)userProfileWithServerResponse:(NSDictionary *)response;

+ (void)encodeUserProfile:(BZRUserProfile *)userProfile
                withCoder:(NSCoder *)encoder;
+ (BZRUserProfile *)decodeUserProfile:(BZRUserProfile *)userProfile
                          withDecoder:(NSCoder *)decoder;

+ (void)setUserProfile:(BZRUserProfile *)userProfile toDefaultsForKey:(NSString *)key;
+ (BZRUserProfile *)userProfileFromDefaultsForKey:(NSString *)key;

@end
