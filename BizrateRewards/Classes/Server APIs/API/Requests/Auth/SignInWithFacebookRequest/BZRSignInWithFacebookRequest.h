//
//  BZRSignInWithFacebookRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@class BZRUserToken;

@interface BZRSignInWithFacebookRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRUserToken *userToken;

@end
