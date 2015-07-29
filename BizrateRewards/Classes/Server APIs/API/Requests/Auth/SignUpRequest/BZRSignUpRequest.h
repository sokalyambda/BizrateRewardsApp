//
//  BZRSignUpRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthRequest.h"

@class BZRUserToken;

@interface BZRSignUpRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRUserToken *userToken;

//Email
- (instancetype)initWithUserFirstName:(NSString *)firstName
                      andUserLastName:(NSString *)lastName
                             andEmail:(NSString *)email
                          andPassword:(NSString *)password
                       andDateOfBirth:(NSString *)birthDate
                            andGender:(NSString *)gender;

//Facebook
- (instancetype)initWithUserFirstName:(NSString *)firstName
                      andUserLastName:(NSString *)lastName
                             andEmail:(NSString *)email
                       andDateOfBirth:(NSString *)birthDate
                            andGender:(NSString *)gender;

@end
