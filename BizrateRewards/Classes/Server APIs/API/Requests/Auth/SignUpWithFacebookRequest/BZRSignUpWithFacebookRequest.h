//
//  BZRSignUpWithFacebookRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@class BZRUserToken;

@interface BZRSignUpWithFacebookRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRUserToken *userToken;

- (instancetype)initWithUserFirstName:(NSString *)firstName
                      andUserLastName:(NSString *)lastName
                             andEmail:(NSString *)email
                       andDateOfBirth:(NSString *)birthDate
                            andGender:(NSString *)gender;

@end
