//
//  BZRGetPointsForNextSurveyRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 12.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetPointsForNextSurveyRequest.h"

#import "BZRSurvey.h"

#import "BZRSurveyService.h"

@implementation BZRGetPointsForNextSurveyRequest

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            BZRSurvey *nextSurvey = [BZRSurveyService surveyFromServerResponse:((NSArray *)responseObject).firstObject];
            self.pointsForNextSurvey = nextSurvey.surveyPoints;
        }
        return YES;
    }
}

@end
