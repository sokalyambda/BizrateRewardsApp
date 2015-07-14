//
//  BZRSurvey.m
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurvey.h"

static NSString *const kSurveyId    = @"surveyId";
static NSString *const kSurveyLink  = @"url";
static NSString *const kRefSurveyId = @"refSurveyId";
static NSString *const kSurveyName  = @"name";

@implementation BZRSurvey

#pragma mark - Lifecycle

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _surveyId       = response[kSurveyId];
        _surveyLink     = [NSURL URLWithString:response[kSurveyLink]];
        _surveyName     = response[kSurveyName];
        _refSurveyId    = response[kRefSurveyId];
    }
    return self;
}

@end
