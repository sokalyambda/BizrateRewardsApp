//
//  BZRFacebookProfileService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@interface BZRFacebookProfileService : NSObject

+ (BZRFacebookProfile *)facebookProfileFromServerResponse:(NSDictionary *)response;

+ (void)encodeFacebookProfile:(BZRFacebookProfile *)facebookProfile
                    withCoder:(NSCoder *)encoder;
+ (BZRFacebookProfile *)decodeFacebookProfile:(BZRFacebookProfile *)facebookProfile
                                  withDecoder:(NSCoder *)decoder;

+ (void)setFacebookProfile:(BZRFacebookProfile *)facebookProfile
          toDefaultsForKey:(NSString *)key;
+ (BZRFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key;

@end
