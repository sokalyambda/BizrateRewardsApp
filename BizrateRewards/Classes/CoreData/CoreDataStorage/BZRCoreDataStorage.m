//
//  BZRCoreDataStorage.m
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRCoreDataStorage.h"

#import "BZRCoreDataManager.h"

#import "BZREnvironment.h"
#import "FacebookProfile.h"
#import "FacebookAccessToken.h"

@implementation BZRCoreDataStorage

+ (BZRCoreDataManager *)coreDataManager
{
    return [BZRCoreDataManager sharedCoreDataManager];
}

#pragma mark - Fetch Entities
#pragma mark - Environment

+ (BZREnvironment *)addNewEnvironmentWithName:(NSString *)environmentName
                   andAPIEndpointURLString:(NSString *)apiEndpoint
                          andMixpanelToken:(NSString *)mixpanelToken
{
    BZREnvironment *environment = (BZREnvironment *)[self.coreDataManager addNewManagedObjectForName:NSStringFromClass([BZREnvironment class])];
    
    environment.environmentName         = environmentName;
    environment.apiEndpointURLString    = apiEndpoint;
    environment.mixPanelToken           = mixpanelToken;
    
    [self saveContext];
    
    return environment;
}

+ (BZREnvironment *)getEnvironmentByName:(NSString *)envName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"environmentName == %@", envName];
    NSArray *filteredArray = [self.coreDataManager getEntities:NSStringFromClass([BZREnvironment class]) byPredicate:predicate];
    return [filteredArray firstObject];
}

+ (BZREnvironment *)getCurrentEnvironment
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCurrent == YES"];
    NSArray *filteredArray = [self.coreDataManager getEntities:NSStringFromClass([BZREnvironment class]) byPredicate:predicate];
    return [filteredArray firstObject];
}

+ (NSArray *)getAllEnvironments
{
    return [self.coreDataManager getEntities:NSStringFromClass([BZREnvironment class])];
}

#pragma mark - Facebook Profile

+ (FacebookProfile *)addFacebookProfileWithFirstName:(NSString *)firstName
                                         andLastName:(NSString *)lastName
                                         andFullName:(NSString *)fullName
                                     andGenderString:(NSString *)genderString
                                            andEmail:(NSString *)email
                                  andAvatarURLString:(NSString *)avatarURLString
                                           andUserId:(long long)userId
{
    FacebookProfile *facebookProfile = (FacebookProfile *)[self.coreDataManager addNewManagedObjectForName:NSStringFromClass([FacebookProfile class])];
    facebookProfile.firstName = firstName;
    facebookProfile.lastName = lastName;
    facebookProfile.fullName = fullName;
    facebookProfile.genderString = genderString;
    facebookProfile.email = email;
    facebookProfile.facebookUserId = @(userId);
    
    [self saveContext];
    return facebookProfile;
}

+ (FacebookProfile *)getCurrentFacebookProfile
{
    NSArray *profiles = [self.coreDataManager getEntities:NSStringFromClass([FacebookProfile class])];
    return [profiles firstObject];
}

+ (void)removeFacebookProfile:(FacebookProfile *)facebookProfile
{
    [self removeObject:facebookProfile];
}

#pragma mark - Facebook Access Token

+ (FacebookAccessToken *)addFacebookAccessTokenWithTokenValue:(NSString *)tokenValue
                                            andExpirationDate:(NSDate *)expDate
{
    FacebookAccessToken *facebookToken = (FacebookAccessToken *)[self.coreDataManager addNewManagedObjectForName:NSStringFromClass([FacebookAccessToken class])];
    
    facebookToken.tokenValue = tokenValue;
    facebookToken.expirationDate = expDate;
    [self saveContext];
    return facebookToken;
}

#pragma mark - Actions

+ (void)saveContext
{
    [self.coreDataManager saveContext];
}

+ (void)removeObject:(NSManagedObject *)managedObject
{
    [self.coreDataManager deleteManagedObject:managedObject];
    [self saveContext];
}

@end
