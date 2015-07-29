//
//  BZRSignInRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 14.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthRequest.h"

@interface BZRSignInRequest : BZRBaseAuthRequest

- (instancetype)initWithEmail:(NSString*)email andPassword:(NSString*)password;

@end
