//
//  BZRErrorHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRErrorHandler.h"

#import "NSString+JSONRepresentation.h"

static NSString *const kErrors = @"errors";
static NSString *const kErrorMessage = @"error_message";
static NSString *const kErrorDescription = @"error_description";

@implementation BZRErrorHandler

/**
 *  Get string value from network error
 *
 *  @param error Error that should be parsed
 *
 *  @return String value from current error
 */
+ (NSString *)stringFromNetworkError:(NSError *)error
{
    NSString *errFromJsonString = [self errorStringFromJSONResponseError:error];
    if (errFromJsonString) {
        return errFromJsonString;
    }
    NSString *errFromCodeString = [self errorStringFromErrorCode:error];
    if (errFromCodeString) {
        return errFromCodeString;
    }
    
    NSString *errLocalizedDescription = error.localizedDescription;
    return errLocalizedDescription;
}

/**
 *  Get string value from server response error
 *
 *  @param error Error that should be parsed
 *
 *  @return String value from current error
 */
+ (NSString *)errorStringFromJSONResponseError:(NSError *)error
{
    NSData *errData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSMutableString *outputErrorString = [NSMutableString string];
    
    if (errData) {
        NSString *jsonErrorString = [[NSString alloc] initWithData:errData encoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonErrorDict = [jsonErrorString dictionaryFromJSONString];
        
        NSArray *errors = jsonErrorDict[kErrors];
        if (errors) {
            for (NSDictionary *currentErrorDict in errors) {
                [outputErrorString appendFormat:@"%@\n", currentErrorDict[kErrorMessage]];
            }
        }
        
        NSString *errorDescriptionString = jsonErrorDict[kErrorDescription];
        
        if (errorDescriptionString.length) {
            [outputErrorString appendString:errorDescriptionString];
        }
    
    }
        return outputErrorString.length > 0 ? outputErrorString : nil;
}

/**
 *  Get string value from error by code
 *
 *  @param error Error that should be parsed
 *
 *  @return String value from current error
 */
+ (NSString *)errorStringFromErrorCode:(NSError *)error
{
    NSString *errString;
    switch (error.code) {
        case NSURLErrorTimedOut: {
            errString = LOCALIZED(@"The connection timed out.");
            break;
        }
        case NSURLErrorCannotFindHost: {
            errString = LOCALIZED(@"The connection failed because the host could not be found.");
            break;
        }
        case NSURLErrorCannotConnectToHost: {
            errString = LOCALIZED(@"The connection failed because a connection cannot be made to the host.");
            break;
        }
        case NSURLErrorNetworkConnectionLost: {
            errString = LOCALIZED(@"The connection failed because the network connection was lost.");
            break;
        }
        case NSURLErrorDNSLookupFailed: {
            errString = LOCALIZED(@"The connection failed because the DNS lookup failed.");
            break;
        }
        case NSURLErrorNotConnectedToInternet: {
            errString = LOCALIZED(@"The connection failed because the device is not connected to the internet.");
            break;
        }
        case NSURLErrorInternationalRoamingOff: {
            errString = LOCALIZED(@"International roaming is off.");
            break;
        }
        case NSURLErrorCallIsActive: {
            errString = LOCALIZED(@"Call is active.");
            break;
        }
        case NSURLErrorDataNotAllowed: {
            errString = LOCALIZED(@"Data not allowed.");
            break;
        }
            
        default:
            break;
    }
    
    return errString.length > 0 ? errString : nil;
}

/**
 *  Checking whether error is a network error
 *
 *  @param error Error for checking
 *
 *  @return If error is network error - returns 'YES'
 */
+ (BOOL)errorIsNetworkError:(NSError *)error
{
    if (error == nil) {
        return NO;
    }
    
    NSError *innerError = error.userInfo[NSUnderlyingErrorKey];
    if ([self errorIsNetworkError:innerError]) {
        return YES;
    }
    
    switch (error.code) {
        case NSURLErrorTimedOut:
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorDNSLookupFailed:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorInternationalRoamingOff:
        case NSURLErrorCallIsActive:
        case NSURLErrorDataNotAllowed:
            return YES;
        default:
            return NO;
    }
}

@end
