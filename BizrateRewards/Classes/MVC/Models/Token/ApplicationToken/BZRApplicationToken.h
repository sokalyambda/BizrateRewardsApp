//
//  BZRApplicationToken.h
//  BizrateRewards
//
//  Created by Eugenity on 06.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRApplicationToken : NSObject<BZRMappingProtocol> {
    NSString *_accessToken;
}

@property (strong, nonatomic, readonly) NSString *accessToken;
@property (strong, nonatomic, readonly) NSDate *expirationDate;
@property (strong, nonatomic) NSString *scope;
@property (strong, nonatomic) NSString *tokenType;

@end
