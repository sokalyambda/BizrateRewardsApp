//
//  BZRUpdateCurrentUserRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 25.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRUpdateCurrentUserRequest.h"

#import "BZRStorageManager.h"

#import "BZRUserProfile.h"

static NSString *const requestAction = @"user/me";

static NSString *const kFirstName = @"firstname";
static NSString *const kLastName = @"lastname";
static NSString *const kGender = @"gender";
static NSString *const kDateOfBirth = @"dob";

@implementation BZRUpdateCurrentUserRequest

- (instancetype)initWithFirstName:(NSString *)firstName
                      andLastName:(NSString *)lastName
                   andDateOfBirth:(NSString *)dateOfBirth
                        andGender:(NSString *)gender
{
    self = [super init];
    if (self) {
        
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.action = [self requestAction];
        _method = @"PUT";
        _autorizationRequired = YES;
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        
        NSDictionary *parameters = @{kFirstName: firstName, kLastName: lastName, kGender: gender, kDateOfBirth: dateOfBirth};
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.updatedProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        return !!self.updatedProfile;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
