//
//  BZRSurveyService.m
//  BizrateRewards
//
//  Created by Eugenity on 12.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyService.h"

#import "BZRProjectFacade.h"

@implementation BZRSurveyService

+ (void)getEligibleSurveysOnSuccess:(EligibleSurveysBlock)success onFailure:(FailureBlock)failure
{
    [BZRProjectFacade getEligibleSurveysOnSuccess:success onFailure:failure];
}

+ (void)getPointsForNextSurveyOnSuccess:(PointsForNextSurveyBlock)success onFailure:(FailureBlock)failure
{
    [BZRProjectFacade getPointsForNextSurveyOnSuccess:success onFailure:failure];
}

@end
