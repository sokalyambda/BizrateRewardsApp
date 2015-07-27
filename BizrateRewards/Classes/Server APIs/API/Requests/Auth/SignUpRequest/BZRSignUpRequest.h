//
//  BZRSignUpRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthRequest.h"

@class BZRUserToken;

@interface BZRSignUpRequest : BZRBaseAuthRequest

@property (strong, nonatomic) BZRUserToken *userToken;

- (instancetype)initWithUserFirstName:(NSString *)firstName
                      andUserLastName:(NSString *)lastName
                             andEmail:(NSString *)email
                          andPassword:(NSString *)password
                       andDateOfBirth:(NSString *)birthDate
                            andGender:(NSString *)gender;

@end
