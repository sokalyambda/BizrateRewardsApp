//
//  BZRGetEligibleSurveysRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 26.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetEligibleSurveysRequest.h"

#import "BZRSurvey.h"

#import "BZRStorageManager.h"

static NSString *requestAction = @"user/survey/eligible";

@implementation BZRGetEligibleSurveysRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.serializationType = BZRRequestSerializationTypeHTTP;
        self.action = [self requestAction];
        _method = @"GET";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;

        [self setParametersWithParamsData:nil];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        NSMutableArray *surveys = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *responseDict in responseObject) {
                BZRSurvey *survey = [[BZRSurvey alloc] initWithServerResponse:responseDict];
                [surveys addObject:survey];
            }
        }
        self.eligibleSurveys = [NSArray arrayWithArray:surveys];
        
        return !!self.eligibleSurveys;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
