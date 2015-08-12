//
//  BZRErrorHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRErrorHandler.h"

#import "NSString+JSONRepresentation.h"

static NSString *const kErrors              = @"errors";
static NSString *const kErrorMessage        = @"error_message";
static NSString *const kErrorDescription    = @"error_description";
static NSString *const kErrorStatusCode     = @"error_code";

@implementation BZRErrorHandler

#pragma mark - Public methods

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

/**
 *  Check whether current email address has already been registered
 *
 *  @param error Error that should be parsed
 *
 *  @return 'YES' if email registered
 */
+ (BOOL)isEmailRegisteredFromError:(NSError *)error
{
    NSArray *errors = [self getErrorsArrayDataFromError:error];
    
    BOOL isRegistered = YES;
    for (NSDictionary *errorDict in errors) {
        if ([errorDict[kErrorStatusCode] isEqualToString:@"EMAIL_NOT_REGISTERED"]) {
            isRegistered = NO;
            break;
        }
    }
    return isRegistered;
}

/**
 *  Check whether current facebook user has already been registered
 *
 *  @param error Error that should be parsed
 *
 *  @return 'YES' if registered
 */
+ (BOOL)isFacebookUserExistsFromError:(NSError *)error
{
    NSArray *errors = [self getErrorsArrayDataFromError:error];
    
    BOOL userExists = YES;
    for (NSDictionary *errorDict in errors) {
        if ([errorDict[kErrorStatusCode] isEqualToString:@"FACEBOOK_USER_NOT_FOUND"]) {
            userExists = NO;
            break;
        }
    }
    return userExists;
}

#pragma mark - Private methods

/**
 *  Get string value from server response error
 *
 *  @param error Error that should be parsed
 *
 *  @return String value from current error
 */
+ (NSString *)errorStringFromJSONResponseError:(NSError *)error
{
    NSMutableString *outputErrorString = [NSMutableString string];
    
    NSArray *errors = [self getErrorsArrayDataFromError:error];
    if (errors) {
        for (NSDictionary *currentErrorDict in errors) {
            [outputErrorString appendFormat:@"%@\n", [self localizedStringFromErrorCode:currentErrorDict[kErrorStatusCode]]];
        }
    } else {
        NSDictionary *jsonErrorDict = [self getErrorsDictDataFromError:error];
        NSString *errorDescriptionString = jsonErrorDict[kErrorDescription];
        
        if (errorDescriptionString.length) {
            [outputErrorString appendString:errorDescriptionString];
        }
    }
    
    return outputErrorString.length > 0 ? outputErrorString : nil;
}

/**
 *  Get array with errors
 *
 *  @param error Error that shoud be parsed
 *
 *  @return Array of dictionaries each of which represents an error
 */
+ (NSArray *)getErrorsArrayDataFromError:(NSError *)error
{
    NSDictionary *jsonErrorDict = [self getErrorsDictDataFromError:error];
    NSArray *errors = jsonErrorDict[kErrors];
    return errors;
}

/**
 *  Get dictionary thar represents an error
 *
 *  @param error Error that should be parsed
 *
 *  @return Error dictionaty
 */
+ (NSDictionary *)getErrorsDictDataFromError:(NSError *)error
{
    NSData *errData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSDictionary *jsonErrorDict;
    if (errData) {
        NSString *jsonErrorString = [[NSString alloc] initWithData:errData encoding:NSUTF8StringEncoding];
        jsonErrorDict = [jsonErrorString dictionaryFromJSONString];
    }
    return jsonErrorDict;
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
        case NSURLErrorDNSLookupFailed: {
            errString = LOCALIZED(@"DNS lookup failed.");
            break;
        }
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorNetworkConnectionLost: {
            errString = LOCALIZED(@"Network connection failed. Check your signal and try again.");
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
 *  Get localized string that depends on error code (custom error code, API specification.)
 *
 *  @param errorCode String value that represents error's code
 *
 *  @return Localized result string
 */
+ (NSString *)localizedStringFromErrorCode:(NSString *)errorCode
{
    NSString *resultString;
    if ([errorCode isEqualToString:@"EMAIL_ALREADY_REGISTERED"]) {
        resultString = LOCALIZED(@"An account with this email address already exists.");
    } else if ([errorCode isEqualToString:@"FACEBOOK_USER_NOT_FOUND"]) {
        resultString = LOCALIZED(@"There is no existed user with this email.");
    } else if ([errorCode isEqualToString:@"PASSWORD_INVALID"]) {
        resultString = LOCALIZED(@"Invalid password. Password must consist of 8 to 16 characters with at least one uppercase and one lowercase letter.");
    } else if ([errorCode isEqualToString:@"GENDER_INVALID_ENTRY"]) {
        resultString = LOCALIZED(@"Gender must be M or F.");
    } else if ([errorCode isEqualToString:@"DOB_INVALID"]) {
        resultString = LOCALIZED(@"Invalid date of birth. You must be of age 13 or older to register.");
    } else if ([errorCode isEqualToString:@"EMAIL_INVALID_FORMAT"]) {
        resultString = LOCALIZED(@"Email must conform to valid email format.");
    } else if ([errorCode isEqualToString:@"LASTNAME_INVALID"]) {
        resultString = LOCALIZED(@"Lastname must consist of letters only.");
    } else if ([errorCode isEqualToString:@"FIRSTNAME_INVALID"]) {
        resultString = LOCALIZED(@"Firstname must consist of letters only.");
    } else if ([errorCode isEqualToString:@"EMAIL_NOT_REGISTERED"]) {
        resultString = LOCALIZED(@"Email address is not registered.");
    }
    return resultString;
}

@end
