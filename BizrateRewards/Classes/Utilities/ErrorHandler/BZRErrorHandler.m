//
//  BZRErrorHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRErrorHandler.h"

#import "NSString+JSONRepresentation.h"
#import "NSError+HTTPResponseStatusCode.h"

static NSString *const kErrors              = @"errors";
static NSString *const kErrorMessage        = @"error_message";
static NSString *const kErrorDescription    = @"error_description";
static NSString *const kErrorStatusCode     = @"error_code";

static NSString *const kFacebookUserNotFound        = @"FACEBOOK_USER_NOT_FOUND";
static NSString *const kEmailNotRegistered          = @"EMAIL_NOT_REGISTERED";

static NSString *const kEmailAlreadyExist           = @"EMAIL_ALREADY_REGISTERED";
static NSString *const kFacebookEmailAlreadyExist   = @"FACEBOOK_USER_ALREADY_REGISTERED";

static NSString *const kBadCredentialsErrorDescription = @"Bad credentials";

static NSString *const kErrorsCodesPlistName = @"ErrorsCodes";
static NSString *const kUserDosentExistForEmail = @"User does not exist for email:";

static NSInteger const kNotAuthorizedStatusCode = 401.f;

@implementation BZRErrorHandler

#pragma mark - Accessors

static NSString *_errorAlertTitle = nil;

+ (NSString *)getErrorAlertTitle
{
    if (!_errorAlertTitle) {
        _errorAlertTitle = @"";
    }
    return _errorAlertTitle;
}

+ (void)setErrorAlertTitle:(NSString *)title
{
    _errorAlertTitle = title;
}

#pragma mark - Public methods

/**
 *  Parse error and get alert title and message
 *
 *  @param error      Error that should be parsed
 *  @param completion Completion Block
 */
+ (void)parseError:(NSError *)error withCompletion:(ErrorParsingCompletion)completion
{
    [self setErrorAlertTitle:@""];

    NSString *errFromJsonString = [self errorStringFromJSONResponseError:error];
    if ([errFromJsonString isEqualToString:kBadCredentialsErrorDescription]) {
        return completion([self getErrorAlertTitle], LOCALIZED(@"Invalid username or password. Please try again"));
    }
    if ([errFromJsonString hasPrefix: kUserDosentExistForEmail]) {
        return completion([self getErrorAlertTitle], LOCALIZED(@"This email does not exist, please create an account"));
    }
    if ([self isEmailNotRegisteredFromError:error]) {
        return completion([self getErrorAlertTitle], LOCALIZED(@"Email address is not registered."));
    }
    NSInteger statusCode = error.HTTPResponseStatusCode;
    if (statusCode == kNotAuthorizedStatusCode) {
        return completion([self getErrorAlertTitle], LOCALIZED(@"Session is invalid, try to sign-in again."));
    } else {
        return completion([self getErrorAlertTitle], LOCALIZED(@"Sorry, something went wrong. Please try again."));
    }

    /*Get error string from jsonResponse
     
    NSString *errFromJsonString = [self errorStringFromJSONResponseError:error];
    if (errFromJsonString) {
        return completion([self getErrorAlertTitle], errFromJsonString);
    }
    NSString *errFromCodeString = [self errorStringFromErrorCode:error];
    if (errFromCodeString) {
        return completion([self getErrorAlertTitle], errFromCodeString);
    }
    
    NSString *errLocalizedDescription = error.localizedDescription;
    
    return completion([self getErrorAlertTitle], errLocalizedDescription);
     */
    
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
        if ([errorDict[kErrorStatusCode] isEqualToString:kEmailNotRegistered]) {
            isRegistered = NO;
            break;
        }
    }
    return isRegistered;
}
/**
 *  Check whether current email address has not been registered
 *
 *  @param error Error that should be parsed
 *
 *  @return 'YES' if email is not registered
 */
+ (BOOL)isEmailNotRegisteredFromError:(NSError *)error
{
    NSArray *errors = [self getErrorsArrayDataFromError:error];
    
    BOOL isNotRegistered = NO;
    for (NSDictionary *errorDict in errors) {
        if ([errorDict[kErrorStatusCode] isEqualToString:kEmailNotRegistered]) {
            isNotRegistered = YES;
            break;
        }
    }
    return isNotRegistered;
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
        if ([errorDict[kErrorStatusCode] isEqualToString:kFacebookUserNotFound]) {
            userExists = NO;
            break;
        }
    }
    return userExists;
}

/**
 *  Check whether this email has already registered
 *
 *  @param error Error that should be parsed
 *
 *  @return 'YES' if registered
 */
+ (BOOL)isEmailAlreadyExistFromError:(NSError *)error
{
    NSArray *errors = [self getErrorsArrayDataFromError:error];
    
    BOOL emailExists = NO;
    for (NSDictionary *errorDict in errors) {
        if ([errorDict[kErrorStatusCode] isEqualToString:kEmailAlreadyExist]) {
            emailExists = YES;
            break;
        }
    }
    return emailExists;
}

/**
 *  Check whether this facebook email has already registered
 *
 *  @param error Error that should be parsed
 *
 *  @return 'YES' if registered
 */
+ (BOOL)isFacebookEmailAlreadyExistFromError:(NSError *)error
{
    NSArray *errors = [self getErrorsArrayDataFromError:error];
    
    BOOL emailExists = NO;
    for (NSDictionary *errorDict in errors) {
        if ([errorDict[kErrorStatusCode] isEqualToString:kFacebookEmailAlreadyExist]) {
            emailExists = YES;
            break;
        }
    }
    return emailExists;
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
        
        if (errorDescriptionString && errorDescriptionString.length) {
            [outputErrorString appendString:errorDescriptionString];
        }
    }
    
    return outputErrorString.length ? outputErrorString : nil;
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
    __block NSString *resultString;
    NSArray *preservedErrorsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kErrorsCodesPlistName ofType:@"plist"]];
    
    [preservedErrorsArray enumerateObjectsUsingBlock:^(NSDictionary *errorDict, NSUInteger idx, BOOL *stop) {
        if (errorDict[errorCode]) {
            resultString = LOCALIZED(errorDict[errorCode][kErrorAlertMessage]);
            [self setErrorAlertTitle:LOCALIZED(errorDict[errorCode][kErrorAlertTitle])];
            *stop = YES;
        }
    }];
    return resultString;
}

@end
