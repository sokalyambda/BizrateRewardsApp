//
//  BZRKeychainHandler.h
//  BizrateRewards
//
//  Created by Eugenity on 16.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRKeychainHandler : NSObject

+ (void)storeCredentialsWithUsername:(NSString*)username andPassword:(NSString*)password;
+ (NSDictionary*)getStoredCredentials;

+ (void)resetKeychain;

@end
