//
//  BZRAuhorizationService.h
//  BizrateRewards
//
//  Created by Eugenity on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class BZRApplicationToken;

typedef void(^AuthorizationSuccessBlock)(BZRApplicationToken *token);
typedef void(^AuthorizationFailureBlock)(NSError *error);

@interface BZRAuthorizationService : NSObject

+ (void)signInWithUserName:(NSString *)userName password:(NSString *)password onSuccess:(AuthorizationSuccessBlock)success onFailure:(AuthorizationFailureBlock)failure;
+ (void)signUpWithUserFirstName:(NSString *)firstName
                andUserLastName:(NSString *)lastName
                       andEmail:(NSString *)email
                    andPassword:(NSString *)password
                 andDateOfBirth:(NSString *)birthDate
                      andGender:(NSString *)gender
                      onSuccess:(AuthorizationSuccessBlock)success
                      onFailure:(AuthorizationFailureBlock)failure;

@end
