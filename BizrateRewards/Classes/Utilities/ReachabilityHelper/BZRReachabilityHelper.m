//
//  BZRReachabilityHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRReachabilityHelper.h"

#import "BZRProjectFacade.h"

@implementation BZRReachabilityHelper

+ (void)checkConnectionOnSuccess:(void (^)())success failure:(void (^)(NSError *error))failure
{
    BOOL isInternetAvaliable = [self isInternetAvaliable];
    if (isInternetAvaliable) {
        if (success) {
            success();
        }
    } else {
        NSError *internetError = [NSError errorWithDomain:@"Internet error" code:NSURLErrorNotConnectedToInternet userInfo:@{NSURLErrorKey: @"Internet error"}];
        if (failure) {
            failure(internetError);
        }
    }
}

+ (BOOL)isInternetAvaliable
{
    return [BZRProjectFacade isInternetReachable];
}

@end
