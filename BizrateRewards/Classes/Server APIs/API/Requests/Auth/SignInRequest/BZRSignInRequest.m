//
//  BZRSignInRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 14.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignInRequest.h"

static NSString *kEmail     = @"username";
static NSString *kPassword  = @"password";

@implementation BZRSignInRequest

#pragma mark - Lifecycle

- (instancetype)initWithEmail:(NSString*)email andPassword:(NSString*)password
{
    if (self = [super init]) {
        
        [self.baseAuthParameters setObject:email forKey:kEmail];
        [self.baseAuthParameters setObject:password forKey:kPassword];
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        [self setParametersWithParamsData:self.baseAuthParameters];
    }
    return self;
}

- (NSString *)grantType
{
    return kPassword;
}

@end
