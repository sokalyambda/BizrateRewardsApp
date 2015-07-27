//
//  BZRUpdateCurrentUserRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@class BZRUserProfile;

@interface BZRUpdateCurrentUserRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRUserProfile *updatedProfile;

- (instancetype)initWithFirstName:(NSString *)firstName
                      andLastName:(NSString *)lastName
                   andDateOfBirth:(NSString *)dateOfBirth
                        andGender:(NSString *)gender;

@end
