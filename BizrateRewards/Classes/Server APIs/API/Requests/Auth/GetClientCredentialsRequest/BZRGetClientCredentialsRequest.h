//
//  BZRGetClientCredentialsRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 26.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthRequest.h"

@class BZRApplicationToken;

@interface BZRGetClientCredentialsRequest : BZRBaseAuthRequest

@property (strong, nonatomic) BZRApplicationToken *applicationToken;

@end
