//
//  BZRSurveysService.m
//  BizrateRewards
//
//  Created by Eugenity on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveysService.h"

#import "BZRDataManager.h"

#import "BZRSurvey.h"

@interface BZRSurveysService ()

@property (strong, nonatomic) BZRDataManager *dataManager;

@end

@implementation BZRSurveysService

#pragma mark - Accessors

+ (void)getSurveysListOnSuccess:(SurveysListSuccess)success onFailure:(SurveysListFailure)failure
{
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        
        [[BZRDataManager sharedInstance] validateSessionWithType:BZRSessionTypeUser withCompletion:^(BOOL isValid, NSError *error) {
            
            if (isValid) {
                [[BZRDataManager sharedInstance] getSurveysListOnSuccess:^(id responseObject) {
                    
                    NSMutableArray *surveys = [NSMutableArray array];
                    if ([responseObject isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *responseDict in responseObject) {
                            BZRSurvey *survey = [[BZRSurvey alloc] initWithServerResponse:responseDict];
                            [surveys addObject:survey];
                        }
                    }
                    success(surveys);
                } onFailure:^(NSError *error) {
                    failure(error);
                }];
                
            } else {
                failure(error);
            }
        }];
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
        failure(nil);
    }];
}

@end
