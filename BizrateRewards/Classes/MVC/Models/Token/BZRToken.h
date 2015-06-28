//
//  BZRToken.h
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRToken : NSObject<BZRMappingProtocol>

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *scope;
@property (strong, nonatomic) NSString *tokenType;

@end
