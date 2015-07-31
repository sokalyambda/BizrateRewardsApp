//
//  BZRCustomURLHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

/*
 com.bizraterewards://reset_password/success?acces_token=123123123123
 
 com.bizraterewards://reset_password/fail?reason=invalid_link
 
 com.bizraterewards://reset_password/fail?reason=expired_link
 
 com.bizraterewards://reset_password/fail?reason=rejected
*/

#import "BZRCustomURLHandler.h"

static NSString *const kSuccessParam = @"success?";
static NSString *const kFailParam = @"fail?";

static NSString *const kAccessToken = @"access_token";
static NSString *const kReason = @"reason";

static NSString *const kInvalidLinkReason = @"invalid_link";
static NSString *const kExpiredLinkReacon = @"expired_link";
static NSString *const kRejectedReason = @"rejected";

static NSString *const kIsResettingSuccess = @"isResettingSuccess";

@implementation BZRCustomURLHandler

+ (NSDictionary *)urlParsingParametersFromURL:(NSURL *)url
{
    NSString *urlString = url.absoluteString;
    
    NSMutableDictionary *urlParsingParameters = [NSMutableDictionary dictionary];
    
    if ([urlString containsString:kSuccessParam]) {
        
        NSRange successRange = [urlString rangeOfString:kSuccessParam];
        NSString *successResetValue = [urlString substringFromIndex:successRange.location+successRange.length];
        
        NSArray *params = [successResetValue componentsSeparatedByString:@"="];
        NSString *accessTokenValue = [params lastObject];
        
        [urlParsingParameters setObject:accessTokenValue forKey:kAccessToken];
        [urlParsingParameters setObject:@YES forKey:kIsResettingSuccess];
        
    } else if ([urlString containsString:kFailParam]) {
        
        NSRange failRange = [urlString rangeOfString:kFailParam];
        NSString *failResetValue = [urlString substringFromIndex:failRange.location+failRange.length];
        
        NSArray *params = [failResetValue componentsSeparatedByString:@"="];
        NSString *failReasonValue = [params lastObject];
        
        [urlParsingParameters setObject:failReasonValue forKey:kReason];
        [urlParsingParameters setObject:@NO forKey:kIsResettingSuccess];
    }
    
    return urlParsingParameters;
}

@end
