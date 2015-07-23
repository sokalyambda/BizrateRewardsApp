//
//  AlertMessageService.m
//  Pseudo
//
//  Created by Eugenity on 20.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAlertMessageService.h"

#import "BZRErrorHandler.h"

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
    if (!error) {
        return;
    }
    NSString *errorString = [BZRErrorHandler stringFromNetworkError:error];
    ShowAlert(errorString);
}

@end
