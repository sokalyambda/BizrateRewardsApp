//
//  BZRBaseAuthRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 14.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@class BZRUserToken;

@interface BZRBaseAuthRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRUserToken *token;

@property (strong, nonatomic) NSMutableDictionary *baseAuthParameters;

@end
