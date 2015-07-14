//
//  BZRSurvey.h
//  BizrateRewards
//
//  Created by Eugenity on 25.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRSurvey : NSObject<BZRMappingProtocol>

@property (strong, nonatomic) NSString *surveyId;
@property (strong, nonatomic) NSURL *surveyLink;

@end
