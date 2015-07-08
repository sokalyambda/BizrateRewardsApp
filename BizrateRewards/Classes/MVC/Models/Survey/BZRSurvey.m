//
//  BZRSurvey.m
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSurvey.h"

static NSString *const kSurveyId = @"id";
static NSString *const kSurveyLink = @"link";

@implementation BZRSurvey

#pragma mark - Lifecycle

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _surveyId   = response[kSurveyId];
        _surveyLink = response[kSurveyLink];
    }
    return self;
}

@end
