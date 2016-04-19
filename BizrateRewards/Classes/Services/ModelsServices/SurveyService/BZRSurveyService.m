//
//  BZRSurveyService.m
//  BizrateRewards
//
//  Created by Eugenity on 12.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyService.h"

#import "BZRSurvey.h"

#import "BZRProjectFacade.h"

static NSString *const kSurveyId    = @"survey_id";
static NSString *const kSurveyLink  = @"url";
static NSString *const kRefSurveyId = @"ref_survey_id";
static NSString *const kSurveyName  = @"name";
static NSString *const kPoints      = @"points";
static NSString *const kDisqualifiedPoints = @"disqualified_points";

@implementation BZRSurveyService

+ (void)getEligibleSurveysOnSuccess:(EligibleSurveysBlock)success onFailure:(FailureBlock)failure
{
    [BZRProjectFacade getEligibleSurveysOnSuccess:success onFailure:failure];
}

+ (void)getPointsForNextSurveyOnSuccess:(PointsForNextSurveyBlock)success onFailure:(FailureBlock)failure
{
    [BZRProjectFacade getPointsForNextSurveyOnSuccess:success onFailure:failure];
}

+ (BZRSurvey *)findSurveyWithId:(NSString *)surveyId inArray:(NSArray *)surveys
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"refSurveyId == %@", surveyId];
    BZRSurvey *survey = [surveys filteredArrayUsingPredicate:predicate].firstObject;
    
    return survey;
}

/**
 *  Survey object mapping
 *
 *  @param response Response Dict
 *
 *  @return Initialized survey
 */
+ (BZRSurvey *)surveyFromServerResponse:(NSDictionary *)response
{
    BZRSurvey *survey = [[BZRSurvey alloc] init];
    survey.surveyId       = [response[kSurveyId] integerValue];
    survey.surveyLink     = [NSURL URLWithString:response[kSurveyLink]];
    survey.surveyName     = response[kSurveyName];
    survey.refSurveyId    = response[kRefSurveyId];
    survey.surveyPoints   = [response[kPoints] integerValue];
    survey.disqualifiedPoints = [response[kDisqualifiedPoints] integerValue];
    return survey;
}

@end
