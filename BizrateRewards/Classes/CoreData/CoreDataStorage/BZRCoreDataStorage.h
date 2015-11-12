//
//  BZRCoreDataStorage.h
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class BZREnvironment, BZRFacebookProfile, BZRFacebookAccessToken;

@interface BZRCoreDataStorage : NSObject

+ (void)saveContext;

//MARK: Environments
+ (BZREnvironment *)addNewEnvironmentWithName:(NSString *)environmentName
                   andAPIEndpointURLString:(NSString *)apiEndpoint
                          andMixpanelToken:(NSString *)mixpanelToken;
+ (BZREnvironment *)getEnvironmentByName:(NSString *)envName;
+ (BZREnvironment *)getCurrentEnvironment;
+ (NSArray *)getAllEnvironments;

//MARK: Facebook Profile
+ (BZRFacebookProfile *)addFacebookProfileWithFirstName:(NSString *)firstName
                                         andLastName:(NSString *)lastName
                                         andFullName:(NSString *)fullName
                                     andGenderString:(NSString *)genderString
                                            andEmail:(NSString *)email
                                  andAvatarURLString:(NSString *)avatarURLString
                                           andUserId:(long long)userId;
+ (BZRFacebookProfile *)getCurrentFacebookProfile;
+ (void)removeFacebookProfile:(BZRFacebookProfile *)facebookProfile;

//MARK: Facebook Access Token
+ (BZRFacebookAccessToken *)addFacebookAccessTokenWithTokenValue:(NSString *)tokenValue
                                            andExpirationDate:(NSDate *)expDate;

@end
