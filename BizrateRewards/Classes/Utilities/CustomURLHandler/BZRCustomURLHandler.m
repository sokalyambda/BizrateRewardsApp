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
 
 com.bizraterewards://reset_password/fail?reason=rejected_link
*/

#import "BZRCustomURLHandler.h"

static NSString *const kSuccessParam = @"success?";
static NSString *const kFailParam = @"fail?";

static NSString *const kAccessToken = @"access_token";

static NSString *const kInvalidLinkReason = @"invalid_link";
static NSString *const kExpiredLinkReacon = @"expired_link";
static NSString *const kRejectedReason = @"rejected_link";

static NSString *const kIsResettingSuccess = @"isResettingSuccess";
static NSString *const kFailReasonMessage = @"failReasonMessage";

//deep survey link
static NSString *const kSurveyPath = @"survey";
static NSString *const kLatestPath = @"latest";

static NSString *const kSurveyId = @"surveyId";

static NSTimeInterval const kSupposedExpirationDate = 86400.f;

@implementation BZRCustomURLHandler

/**
 *  Parse the custom URL and get parameters
 *
 *  @param url URL that shoud be parsed
 *
 *  @return Parsed Parameters
 */
+ (NSDictionary *)urlParsingParametersForPasswordResetFromURL:(NSURL *)url
{
    NSString *urlString = url.absoluteString;
    NSMutableDictionary *urlParsingParameters = [NSMutableDictionary dictionary];
    
    if ([urlString containsString:kSuccessParam]) {
        
        NSRange successRange = [urlString rangeOfString:kSuccessParam];
        NSString *successResetValue = [urlString substringFromIndex:successRange.location+successRange.length];
        NSArray *params = [successResetValue componentsSeparatedByString:@"="];
        NSString *accessTokenValue = [params lastObject];
        
        NSString *supposedExpiresIn = [NSString stringWithFormat:@"%f", kSupposedExpirationDate];
        [urlParsingParameters setObject:accessTokenValue forKey:kAccessToken];
        [urlParsingParameters setObject:@YES forKey:kIsResettingSuccess];
        [urlParsingParameters setObject:supposedExpiresIn forKey:@"expires_in"];
        
        //set temporary token
        BZRUserToken *token = [[BZRUserToken alloc] initWithServerResponse:urlParsingParameters];
        [BZRStorageManager sharedStorage].temporaryUserToken = token;
        
    } else if ([urlString containsString:kFailParam]) {
        
        NSRange failRange = [urlString rangeOfString:kFailParam];
        NSString *failResetValue = [urlString substringFromIndex:failRange.location+failRange.length];
        NSArray *params = [failResetValue componentsSeparatedByString:@"="];
        NSString *failReasonValue = [params lastObject];
        NSString *failReasonMessage;
        if ([failReasonValue isEqualToString:kInvalidLinkReason] || [failReasonValue isEqualToString:kExpiredLinkReacon]) {
            failReasonMessage = LOCALIZED(@"This password reset link has been expired.");
        } else if ([failReasonValue isEqualToString:kRejectedReason]) {
            failReasonMessage = LOCALIZED(@"This password reset link has been expired by a more recent password reset request.");
        }
        
        [urlParsingParameters setObject:@NO forKey:kIsResettingSuccess];
        [urlParsingParameters setObject:failReasonMessage forKey:kFailReasonMessage];
    }
    
    return urlParsingParameters;
}

/**
 *  Parse URL for survey presentation
 */
+ (NSDictionary *)urlParsingParametersForSurveyFromURL:(NSURL *)url
{
    NSMutableDictionary *urlParsingParameters = [@{} mutableCopy];
    
    NSArray *components = url.absoluteString.pathComponents;
    NSString *pathComponentsString = [components componentsJoinedByString:@""];
    NSArray *separatedComponents = [pathComponentsString componentsSeparatedByString:kSurveyPath];
    
    NSString *lastComponent = separatedComponents.lastObject;
    
    [urlParsingParameters setObject:lastComponent forKey:kSurveyId];

    return urlParsingParameters;
}

@end
