//
//  BZRSignUpWithFacebookRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 27.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignUpWithFacebookRequest.h"

#import "BZRUserToken.h"

#import "BZRStorageManager.h"

static NSString *const requestAction = @"user/create";

static NSString *const kFirstName = @"firstname";
static NSString *const kLastName = @"lastname";
static NSString *const kEmail = @"email";
static NSString *const kGender = @"gender";
static NSString *const kDateOfBirth = @"dob";
static NSString *const kIsTestUser = @"is_test_user";

static NSString *const kFacebookParams = @"facebook";
static NSString *const kAccessToken = @"access_token";

@implementation BZRSignUpWithFacebookRequest

- (instancetype)initWithUserFirstName:(NSString *)firstName
                      andUserLastName:(NSString *)lastName
                             andEmail:(NSString *)email
                       andDateOfBirth:(NSString *)birthDate
                            andGender:(NSString *)gender
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].applicationToken.accessToken] forKey:@"Authorization"];
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"POST";
        
        NSString *fbAccessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:FBAccessToken];
        
        NSDictionary *parameters = @{kFirstName: firstName,
                                     kLastName: lastName,
                                     kEmail: email,
                                     kDateOfBirth: birthDate,
                                     kGender: gender,
                                     kIsTestUser: @YES,
                                     kFacebookParams: @{kAccessToken: fbAccessTokenString}};
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
