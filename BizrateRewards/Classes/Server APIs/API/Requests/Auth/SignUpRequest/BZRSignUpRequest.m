//
//  BZRSignUpRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignUpRequest.h"

#import "BZRFacebookAccessToken.h"
#import "BZRFacebookProfile.h"

#import "BZRCoreDataStorage.h"

static NSString *const kFirstName   = @"firstname";
static NSString *const kLastName    = @"lastname";
static NSString *const kEmail       = @"email";
static NSString *const kGender      = @"gender";
static NSString *const kDateOfBirth = @"dob";
static NSString *const kPassword    = @"password";
static NSString *const kIsTestUser  = @"is_test_user";

static NSString *const kFacebookParams = @"facebook";
static NSString *const kAccessToken = @"access_token";

static NSString *const kShareCode   = @"share_code";

static NSString *const requestAction = @"user/create";

@implementation BZRSignUpRequest

#pragma mark - Lifecycle

//Email
- (instancetype)initWithUserFirstName:(NSString *)firstName
                      andUserLastName:(NSString *)lastName
                             andEmail:(NSString *)email
                          andPassword:(NSString *)password
                       andDateOfBirth:(NSString *)birthDate
                            andGender:(NSString *)gender
                         andShareCode:(NSString *)shareCode;
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].applicationToken.accessToken] forKey:@"Authorization"];
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = NO;
        _applicationAuthorizationRequired = YES;
        
        NSMutableDictionary *parameters = [@{kFirstName: firstName,
                                     kLastName: lastName,
                                     kEmail: email,
                                     kPassword: password,
                                     kDateOfBirth: birthDate,
                                             kGender: gender, kIsTestUser :
                                                 @(YES)} mutableCopy];
        if (shareCode) {
            [parameters setObject:shareCode forKey:kShareCode];
        }
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

//Facebook
- (instancetype)initWithUserFirstName:(NSString *)firstName
                      andUserLastName:(NSString *)lastName
                             andEmail:(NSString *)email
                       andDateOfBirth:(NSString *)birthDate
                            andGender:(NSString *)gender
                         andShareCode:(NSString *)shareCode;
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].applicationToken.accessToken] forKey:@"Authorization"];
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = NO;
        _applicationAuthorizationRequired = YES;
        
        NSString *fbAccessTokenString = [BZRCoreDataStorage getCurrentFacebookProfile].facebookAccessToken.tokenValue;
        
        NSMutableDictionary *parameters = [@{kFirstName: firstName,
                                     kLastName: lastName,
                                     kEmail: email,
                                     kDateOfBirth: birthDate,
                                     kGender: gender
                                             }mutableCopy];
        if (fbAccessTokenString) {
            [parameters setObject:@{kAccessToken: fbAccessTokenString} forKey:kFacebookParams];
        }
        if (shareCode) {
            [parameters setObject:shareCode forKey:kShareCode];
        }
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

#pragma mark - Actions

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
