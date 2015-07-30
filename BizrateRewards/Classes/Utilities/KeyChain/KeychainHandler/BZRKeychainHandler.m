//
//  BZRKeychainHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 16.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRKeychainHandler.h"

#import "KeychainItemWrapper.h"

static NSString *const kUserCredentialsKey = @"userCredentialsKey";

@implementation BZRKeychainHandler

/**
 *  Store user private data to keychain, using the KeychainItemWrapper
 *
 *  @param username Username for storing
 *  @param password Password for storing
 */
+ (void)storeCredentialsWithUsername:(NSString*)username andPassword:(NSString*)password
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kUserCredentialsKey accessGroup:nil];
    
    [keychainItem resetKeychainItem];
    
    [keychainItem setObject:username forKey:(__bridge id)(kSecAttrService)];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
}

/**
 *  Get user private data from keychain
 *
 *  @return Dictionary with user private data
 */
+ (NSDictionary*)getStoredCredentials
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kUserCredentialsKey accessGroup:nil];
    
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrService)];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                username,
                                                password,
                                                nil]
                                       forKeys:[NSArray arrayWithObjects:
                                                [NSString stringWithFormat:UserNameKey],
                                                [NSString stringWithFormat:PasswordKey],
                                                nil]];
    
}

/**
 *  Reset keychain data
 */
+ (void)resetKeychain
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kUserCredentialsKey accessGroup:nil];
    
    [keychainItem resetKeychainItem];
}

@end
