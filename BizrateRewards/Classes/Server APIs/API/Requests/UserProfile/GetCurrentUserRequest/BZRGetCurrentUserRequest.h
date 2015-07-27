//
//  BZRGetCurrentUserRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@class BZRUserProfile;

@interface BZRGetCurrentUserRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRUserProfile *currentUserProfile;

@end
