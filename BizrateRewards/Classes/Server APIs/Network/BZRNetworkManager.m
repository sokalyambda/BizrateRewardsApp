//
//  BZRNetworkManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRNetworkManager.h"

NSString *const baseURLString = @"http://mobileapp.vacs.hu.opel.dwt.carusselgroup.com";

@implementation BZRNetworkManager

- (instancetype)init
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    self = [super initWithBaseURL:baseURL];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

#pragma mark - SignIn

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(UserProfileBlock)result
{
    NSDictionary *parameter = @{@"" : userName,
                                @"" : password};
    [self POST:@"" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        BZRUserProfile *userProfile = [[BZRUserProfile alloc] initWithServerResponse:responseObject];
        return result(YES, userProfile, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return result(NO, nil, error);
    }];
}

@end
