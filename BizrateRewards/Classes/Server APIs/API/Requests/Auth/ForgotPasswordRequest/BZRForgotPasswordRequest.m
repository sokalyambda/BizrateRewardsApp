//
//  BZRForgotPasswordRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRForgotPasswordRequest.h"

static NSString *const requestAction = @"resetPassword";

static NSString *const kUsername = @"userName";
static NSString *const kPassword = @"password";

@implementation BZRForgotPasswordRequest

- (instancetype)initWithUserName:(NSString *)userName andNewPassword:(NSString *)newPassword
{
    self = [super init];
    if (self) {
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = NO;
        _applicationAuthorizationRequired = NO;
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        
        NSDictionary *parameters = @{kUsername: userName, kPassword: newPassword};
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (NSString *)requestAction
{
    return requestAction;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
//        self.currentUserProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
//        return !!self.currentUserProfile;
        return YES;
    }
}

@end
