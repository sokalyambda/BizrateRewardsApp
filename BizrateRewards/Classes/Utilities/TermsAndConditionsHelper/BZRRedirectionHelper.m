//
//  BZRTermsAndConditionsHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 13.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRRedirectionHelper.h"
#import "BZRCustomURLHandler.h"

#import "BZRPrivacyAndTermsController.h"
#import "BZRSuccessResettingController.h"
#import "BZRFailureResettingController.h"

static NSString *const kStoryboardName = @"Main";

static NSString *const kIsResettingSuccess = @"isResettingSuccess";

@implementation BZRRedirectionHelper

/**
 *  Show chosen privacy&terms controller
 *
 *  @param type                 Type of privacy
 *  @param navigationController Navigation controller that will push the privacy controller
 */
+ (void)showPrivacyAndTermsWithType:(BZRConditionsType)type andWithNavigationController:(UINavigationController *)navigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:[NSBundle mainBundle]];
    
    BZRPrivacyAndTermsController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPrivacyAndTermsController class])];
    
    NSString *currentURLString;
    
    switch (type) {
        case BZRConditionsTypePrivacyPolicy:
            controller.navigationItem.title = NSLocalizedString(@"Privacy Policy", nil);
            currentURLString = @"urlForPrivacyPolicy";
            break;
        case BZRConditionsTypeTermsAndConditions:
            controller.navigationItem.title = NSLocalizedString(@"Terms and Conditions", nil);
            currentURLString = @"urlForTermsAndConditions";
            break;
        case BZRConditionsTypeUserAgreement:
            controller.navigationItem.title = NSLocalizedString(@"User Agreement", nil);
            currentURLString = @"urlForUserAgreement";
            break;
            
        default:
            break;
    }
    
    controller.currentURL = [NSURL URLWithString:currentURLString];
    [navigationController pushViewController:controller animated:YES];
}

/**
 *  When we get the url on app opening (after password reseting), we have to redirect the user to correctly finish reset password controller to show whether the result was success or failure.
 *
 *  @param redirectURL          URL which has to be parsed for determining destination controller
 *  @param navigationController Navigation controller that will push the needed controller
 */
+ (void)showResetPasswordResultControllerWithObtainedURL:(NSURL *)redirectURL andWithNavigationController:(UINavigationController *)navigationController
{
    NSDictionary *parsedParameters = [BZRCustomURLHandler urlParsingParametersFromURL:redirectURL];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:[NSBundle mainBundle]];
    
    BOOL isResetingSuccess = [parsedParameters[kIsResettingSuccess] boolValue];
    
    BZRBaseViewController *redirectedController;
    
    if (isResetingSuccess) {
        redirectedController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSuccessResettingController class])];
    } else {
        redirectedController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRFailureResettingController class])];
    }
    [navigationController pushViewController:redirectedController animated:YES];
}

@end
