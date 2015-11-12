//
//  BZRCoreDataStorage.h
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class BZREnvironment, FacebookProfile, FacebookAccessToken;

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
+ (FacebookProfile *)addFacebookProfileWithFirstName:(NSString *)firstName
                                         andLastName:(NSString *)lastName
                                         andFullName:(NSString *)fullName
                                     andGenderString:(NSString *)genderString
                                            andEmail:(NSString *)email
                                  andAvatarURLString:(NSString *)avatarURLString
                                           andUserId:(long long)userId;
+ (FacebookProfile *)getCurrentFacebookProfile;
+ (void)removeFacebookProfile:(FacebookProfile *)facebookProfile;

//MARK: Facebook Access Token
+ (FacebookAccessToken *)addFacebookAccessTokenWithTokenValue:(NSString *)tokenValue
                                            andExpirationDate:(NSDate *)expDate;

@end
