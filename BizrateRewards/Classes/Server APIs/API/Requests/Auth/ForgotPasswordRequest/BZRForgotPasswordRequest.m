//
//  BZRForgotPasswordRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRForgotPasswordRequest.h"

static NSString *const requestAction = @"user/password/reset";

static NSString *const kUsername = @"email";
static NSString *const kPassword = @"password";

@implementation BZRForgotPasswordRequest

- (instancetype)initWithUserName:(NSString *)userName andNewPassword:(NSString *)newPassword
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].applicationToken.accessToken] forKey:@"Authorization"];
        
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        
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
