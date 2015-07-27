//
//  BZRGetEligibleSurveysRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 26.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@interface BZRGetEligibleSurveysRequest : BZRNetworkRequest

@property (strong, nonatomic) NSArray *eligibleSurveys;

@end
