//
//  BZRSignInWithFacebookRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignInWithFacebookRequest.h"

#import "BZRUserToken.h"

#import "BZRStorageManager.h"

static NSString *const requestAction = @"user/facebook";

static NSString *const kFacebookAccessToken = @"access_token";

@implementation BZRSignInWithFacebookRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].applicationToken.accessToken] forKey:@"Authorization"];
        
        self.action = [self requestAction];
        _method = @"POST";
        
        NSString *fbAccessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:FBAccessToken];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{kFacebookAccessToken: fbAccessTokenString}];
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.userToken = [[BZRUserToken alloc] initWithServerResponse:responseObject];
        
        return !!self.userToken;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
