//
//  BZRToken.h
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRApplicationToken.h"

@interface BZRUserToken : BZRApplicationToken

@property (strong, nonatomic) NSString *refreshToken;

@end
