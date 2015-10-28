//
//  BZRSurvey.h
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRSurvey : NSObject

@property (strong, nonatomic) NSString *surveyName;
@property (strong, nonatomic) NSString *refSurveyId;
@property (assign, nonatomic) NSInteger surveyId;
@property (strong, nonatomic) NSURL *surveyLink;
@property (assign, nonatomic) NSInteger surveyPoints;

@end
