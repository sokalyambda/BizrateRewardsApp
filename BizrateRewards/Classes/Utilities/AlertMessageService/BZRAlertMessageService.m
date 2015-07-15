//
//  AlertMessageService.m
//  Pseudo
//
//  Created by Eugenity on 20.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAlertMessageService.h"

#import <AFNetworking/AFNetworking.h>

@implementation BZRAlertMessageService

#pragma mark - Alerts

void ShowTitleErrorAlert(NSString *title, NSError *error)
{
    if (!error) {
        return;
    }
    
    NSMutableString *errStr = [NSMutableString stringWithString: NSLocalizedString(@"Error", nil)];
    
//    if (error.code) {
//       [errStr appendFormat:@": %ld", (long)error.code];
//    }
    
    // If the user info dictionary doesn’t contain a value for NSLocalizedDescriptionKey
    // error.localizedDescription is constructed from domain and code by default
    [errStr appendFormat:@"\n%@", error.localizedDescription];
    
    if (error.localizedFailureReason)
        [errStr appendFormat:@"\n%@", error.localizedFailureReason];
    
    if (error.localizedRecoverySuggestion)
        [errStr appendFormat:@"\n%@", error.localizedRecoverySuggestion];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:errStr delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    
    [alert show];
}

void ShowErrorAlert(NSError *error)
{
    ShowTitleErrorAlert(@"", error);
}

void ShowTitleAlert(NSString *title, NSString *message)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}

void ShowAlert(NSString *message)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}

void ShowFailureResponseAlertWithError(NSError *error)
{
    NSData *errData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString *jsonErrorString = [[NSString alloc] initWithData:errData encoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    NSData *objectData = [jsonErrorString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonErrorDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    NSArray *errors = jsonErrorDict[@"errors"];
    
    NSMutableString *outputErrorString = [NSMutableString string];
    
    for (NSDictionary *currentErrorDict in errors) {
        [outputErrorString appendFormat:@"%@\n", currentErrorDict[@"error_message"]];
    }
    
    if (outputErrorString.length) {
        ShowAlert(outputErrorString);
    } else {
        ShowErrorAlert(error);
    }
}

@end
