//
//  BZRRenewSessionTokenRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthRequest.h"

@class BZRUserToken;

@interface BZRRenewSessionTokenRequest : BZRBaseAuthRequest

@property (strong, nonatomic) BZRUserToken *userToken;

@end
