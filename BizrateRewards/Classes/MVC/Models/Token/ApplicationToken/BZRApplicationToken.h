//
//  BZRApplicationToken.h
//  BizrateRewards
//
//  Created by Eugenity on 06.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRApplicationToken : NSObject<BZRMappingProtocol>

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *scope;
@property (strong, nonatomic) NSString *tokenType;

@end
