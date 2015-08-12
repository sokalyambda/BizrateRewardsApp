//
//  BZRSurveyService.h
//  BizrateRewards
//
//  Created by Eugenity on 12.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^PointsForNextSurveyBlock)(NSInteger pointsForNextSurvey);
typedef void(^EligibleSurveysBlock)(NSArray *eligibleSurveys);

typedef void(^FailureBlock)(NSError *error, BOOL isCanceled);

@interface BZRSurveyService : NSObject

+ (void)getEligibleSurveysOnSuccess:(EligibleSurveysBlock)success onFailure:(FailureBlock)failure;
+ (void)getPointsForNextSurveyOnSuccess:(PointsForNextSurveyBlock)success onFailure:(FailureBlock)failure;

@end
