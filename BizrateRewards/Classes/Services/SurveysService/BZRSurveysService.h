//
//  BZRSurveysService.h
//  BizrateRewards
//
//  Created by Eugenity on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^SurveysListSuccess)(NSArray *surveys);
typedef void(^SurveysListFailure)(NSError *error);

@interface BZRSurveysService : NSObject

+ (void)getSurveysListOnSuccess:(SurveysListSuccess)success onFailure:(SurveysListFailure)failure;

@end
